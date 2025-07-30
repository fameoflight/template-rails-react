import { useState, useCallback, useRef, useEffect } from 'react';

interface User {
  id: string;
  name: string;
}

interface UseTypingIndicatorOptions {
  onStartTyping: () => void;
  onStopTyping: () => void;
  typingTimeout?: number; // How long to wait before stopping typing indicator
}

export function useTypingIndicator({
  onStartTyping,
  onStopTyping,
  typingTimeout = 3000
}: UseTypingIndicatorOptions) {
  const [isTyping, setIsTyping] = useState(false);
  const [typingUsers, setTypingUsers] = useState<User[]>([]);
  const typingTimeoutRef = useRef<NodeJS.Timeout | null>(null);
  const lastTypingTimeRef = useRef<number>(0);

  // Handle user starting to type
  const handleTypingStart = useCallback(() => {
    const now = Date.now();
    lastTypingTimeRef.current = now;

    if (!isTyping) {
      setIsTyping(true);
      onStartTyping();
    }

    // Clear existing timeout
    if (typingTimeoutRef.current) {
      clearTimeout(typingTimeoutRef.current);
    }

    // Set new timeout to stop typing
    typingTimeoutRef.current = setTimeout(() => {
      // Only stop if no recent typing activity
      if (Date.now() - lastTypingTimeRef.current >= typingTimeout) {
        setIsTyping(false);
        onStopTyping();
      }
    }, typingTimeout);
  }, [isTyping, onStartTyping, onStopTyping, typingTimeout]);

  // Handle user stopping typing (called when message is sent)
  const handleTypingStop = useCallback(() => {
    if (typingTimeoutRef.current) {
      clearTimeout(typingTimeoutRef.current);
      typingTimeoutRef.current = null;
    }
    
    if (isTyping) {
      setIsTyping(false);
      onStopTyping();
    }
  }, [isTyping, onStopTyping]);

  // Handle incoming typing updates from other users
  const handleTypingUpdate = useCallback((data: { user: User; is_typing: boolean }) => {
    const { user, is_typing } = data;
    
    setTypingUsers(prev => {
      if (is_typing) {
        // Add user to typing list if not already there
        const exists = prev.some(u => u.id === user.id);
        if (!exists) {
          return [...prev, user];
        }
        return prev;
      } else {
        // Remove user from typing list
        return prev.filter(u => u.id !== user.id);
      }
    });
  }, []);

  // Cleanup timeout on unmount
  useEffect(() => {
    return () => {
      if (typingTimeoutRef.current) {
        clearTimeout(typingTimeoutRef.current);
      }
    };
  }, []);

  return {
    isTyping,
    typingUsers,
    handleTypingStart,
    handleTypingStop,
    handleTypingUpdate
  };
}
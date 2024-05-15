import React from 'react';
import { AutoFocusPlugin } from '@lexical/react/LexicalAutoFocusPlugin';
import {
  InitialConfigType,
  LexicalComposer,
} from '@lexical/react/LexicalComposer';
import { ContentEditable } from '@lexical/react/LexicalContentEditable';
import LexicalErrorBoundary from '@lexical/react/LexicalErrorBoundary';
import { HistoryPlugin } from '@lexical/react/LexicalHistoryPlugin';

import { RichTextPlugin } from '@lexical/react/LexicalRichTextPlugin';

import { OnChangePlugin } from '@lexical/react/LexicalOnChangePlugin';

import { AutoLinkNode, LinkNode } from '@lexical/link';

import AutoLinkPlugin from './plugins/AutoLinkPlugin';

import ToolbarPlugin from './plugins/ToolbarPlugin';
import ExampleTheme from './ExampleTheme';

import './styles.css';
import { EditorState } from 'lexical';

function Placeholder({ children }: { children: React.ReactNode }) {
  return (
    <div className="editor-placeholder">{children || 'Type something...'}</div>
  );
}

interface RichTextEditorProps {
  readOnly?: boolean;
  initialContent?: string | null;
  onChange?: (content: string) => void;
  placeholder?: string;
}

function RichTextEditor(props: RichTextEditorProps) {
  const editorConfig: InitialConfigType = {
    namespace: 'RichTextEditor',
    nodes: [AutoLinkNode, LinkNode],
    // Handling of errors during update
    onError(error: Error) {
      throw error;
    },
    // The editor theme
    theme: ExampleTheme,
    editorState: props.initialContent,
    editable: !!!props.readOnly,
  };

  const onChange = (editorState: EditorState) => {
    const editorContent = editorState.toJSON();

    if (props.onChange) {
      props.onChange(JSON.stringify(editorContent));
    }
  };

  const placeholder = props.readOnly ? null : (
    <Placeholder>{props.placeholder || 'Enter Something...'}</Placeholder>
  );

  return (
    <LexicalComposer initialConfig={editorConfig}>
      <div className="editor-container">
        {props.readOnly ? null : <ToolbarPlugin />}
        <div className="editor-inner">
          <RichTextPlugin
            contentEditable={<ContentEditable className="editor-input" />}
            placeholder={placeholder}
            ErrorBoundary={LexicalErrorBoundary}
          />
          <HistoryPlugin />
          <AutoFocusPlugin />
          <OnChangePlugin onChange={onChange} />
          <AutoLinkPlugin />
        </div>
      </div>
    </LexicalComposer>
  );
}

export default RichTextEditor;

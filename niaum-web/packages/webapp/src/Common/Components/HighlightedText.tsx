import React from 'react';

interface IHighlightedTextProps {
  text: string;
  term?: string;
}

const HighlightedText = (props: IHighlightedTextProps) => {
  const highlight = props.term || '';

  if (!highlight.trim()) {
    return <span>{props.text}</span>;
  }
  const regex = new RegExp(`(${highlight})`, 'gi');
  const parts = props.text.split(regex);

  return (
    <span>
      {parts.filter(String).map((part, i) => {
        return regex.test(part) ? (
          <span className="bg-yellow-100 text-yellow-800" key={i}>
            {part}
          </span>
        ) : (
          <span key={i}>{part}</span>
        );
      })}
    </span>
  );
};

export default HighlightedText;

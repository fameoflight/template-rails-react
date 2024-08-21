import { Switch } from 'antd';
import React from 'react';
import RichTextView from './RichTextView';

export type RichTextType = {
  format: 'plain' | 'markdown' | 'html' | 'lexical';
  content: string | null | undefined;
};

interface IRichTextInputProps {
  value?: RichTextType;
  onChange?: (value: RichTextType) => void;
}

function RichTextInput(props: IRichTextInputProps) {
  const [preview, setPreview] = React.useState(false);

  const [value, setValue] = React.useState<RichTextType>({
    format: props.value?.format || 'plain',
    content: props.value?.content || '',
  });

  const format = value?.format || 'plain';

  const content = value?.content || '';

  const onContentChange = (newContent: string) => {
    setValue({
      ...value,
      content: newContent,
    });

    props.onChange?.({
      ...value,
      content: newContent,
    });
  };

  return (
    <div>
      <div className="flex justify-between items-center">
        <div className="text-sm text-gray-500 mt-2">
          Format: {format.toUpperCase()}
        </div>
        <Switch
          checked={preview}
          onChange={setPreview}
          checkedChildren="Preview"
          unCheckedChildren="Edit"
        />
      </div>
      <textarea
        value={content}
        onChange={(e) => onContentChange(e.target.value)}
        className="w-full h-64 p-2 border border-gray-300 rounded-lg"
      />

      {preview ? <RichTextView value={value} /> : null}
    </div>
  );
}

export default RichTextInput;

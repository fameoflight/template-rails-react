import React, { useEffect, useState } from 'react';
import { AutoFocusPlugin } from '@lexical/react/LexicalAutoFocusPlugin';
import {
  InitialConfigType,
  LexicalComposer,
} from '@lexical/react/LexicalComposer';
import { ContentEditable } from '@lexical/react/LexicalContentEditable';
import LexicalErrorBoundary from '@lexical/react/LexicalErrorBoundary';
import { HistoryPlugin } from '@lexical/react/LexicalHistoryPlugin';
import {
  $convertFromMarkdownString,
  $convertToMarkdownString,
  TRANSFORMERS,
} from '@lexical/markdown';

import { RichTextPlugin } from '@lexical/react/LexicalRichTextPlugin';

import { $generateHtmlFromNodes } from '@lexical/html';

import { AutoLinkNode, LinkNode } from '@lexical/link';

import AutoLinkPlugin from './plugins/AutoLinkPlugin';

import ToolbarPlugin from './plugins/ToolbarPlugin';
import ExampleTheme from './ExampleTheme';

import './styles.css';
import { EditorState } from 'lexical';
import type { LexicalEditor } from 'lexical';
import { $getRoot, $createParagraphNode, $createTextNode } from 'lexical';
import { useLexicalComposerContext } from '@lexical/react/LexicalComposerContext';

import { HeadingNode, QuoteNode } from '@lexical/rich-text';
import { ListItemNode, ListNode } from '@lexical/list';
import { CodeHighlightNode, CodeNode } from '@lexical/code';

import type { Transformer } from '@lexical/markdown';

function Placeholder({ children }: { children: React.ReactNode }) {
  return (
    <div className="editor-placeholder">{children || 'Type something...'}</div>
  );
}

export type RichTextEditorOnChange = {
  content: string;
  contentHtml: string;
  contentMarkdown: string;
  format: 'plain' | 'lexical' | 'markdown';
};

function InitialContentPlugin(props: {
  value?: Partial<RichTextEditorOnChange>;
}) {
  const format = props.value?.format || 'lexical';
  const [editor] = useLexicalComposerContext();

  useEffect(() => {
    if (!editor) {
      return;
    }
    editor.update(() => {
      if (format === 'markdown') {
        if (props.value?.contentMarkdown) {
          $convertFromMarkdownString(
            props.value.contentMarkdown,
            TRANSFORMERS as Transformer[]
          );
        } else {
          if (props.value?.content) {
            try {
              const parsedState = editor.parseEditorState(props.value.content);
              editor.setEditorState(parsedState);
            } catch (e) {
              console.error(e);
              $convertFromMarkdownString(
                props.value.content,
                TRANSFORMERS as Transformer[]
              );
            }
          }
        }
      }

      if (format === 'lexical') {
        if (props.value?.content) {
          try {
            const parsedState = editor.parseEditorState(props.value.content);
            editor.setEditorState(parsedState);
          } catch (e) {
            console.error(e);
          }
        } else {
          const root = $getRoot();
          if (root.getFirstChild() === null) {
            const paragraph = $createParagraphNode();
            paragraph.append($createTextNode(''));
            root.append(paragraph);
          }
        }
      }

      if (format === 'plain') {
        const root = $getRoot();
        if (root.getFirstChild() === null) {
          const paragraph = $createParagraphNode();
          paragraph.append($createTextNode(props.value?.content || ''));
          root.append(paragraph);
        }
      }
    });
  }, [editor]);

  return null;
}

function OnChangePlugin({
  onChange,
}: {
  onChange: (
    editorState: EditorState,
    editor: LexicalEditor,
    markdown: string,
    html: string
  ) => void;
}) {
  const [editor] = useLexicalComposerContext();

  useEffect(() => {
    if (!editor) {
      return;
    }

    return editor.registerUpdateListener(({ editorState }) => {
      editorState.read(() => {
        const markdown = $convertToMarkdownString(
          TRANSFORMERS as Transformer[]
        );

        const html = $generateHtmlFromNodes(editor, null);

        onChange(editorState as any, editor as any, markdown, html);
      });
    });
  }, [editor, onChange]);

  return null;
}

interface RichTextEditorProps {
  namespace?: string;
  readOnly?: boolean;
  initialContent?: Partial<RichTextEditorOnChange>;
  onChange?: (value: RichTextEditorOnChange) => void;
  placeholder?: string;
  toolbar?: boolean;
}

function RichTextEditor(props: RichTextEditorProps) {
  const toolbar = props.toolbar ?? true;

  const [isEditorReady, setIsEditorReady] = useState(false);

  const editorConfig: InitialConfigType = {
    namespace: props.namespace || 'default',
    nodes: [
      HeadingNode,
      QuoteNode,
      ListItemNode,
      ListNode,
      CodeHighlightNode,
      CodeNode,
      AutoLinkNode,
      LinkNode,
    ],
    // Handling of errors during update
    onError(error: Error) {
      console.error('Error during update:', error);
      console.error(
        'Make sure you are using different namespaces for different editors'
      );
      throw error;
    },
    // The editor theme
    theme: ExampleTheme,
    editable: !!!props.readOnly,
  };

  const onChange = (
    editorState: EditorState,
    editor: LexicalEditor,
    markdown: string,
    html: string
  ) => {
    const editorContent = JSON.stringify(editorState.toJSON());

    if (props.onChange) {
      props.onChange({
        content: JSON.stringify(editorContent),
        contentHtml: html,
        contentMarkdown: markdown,
        format: props.initialContent?.format || 'lexical',
      });
    }
  };

  const placeholder = props.readOnly ? null : (
    <Placeholder>{props.placeholder || 'Enter Something...'}</Placeholder>
  );

  if (props.readOnly) {
    return (
      <LexicalComposer initialConfig={editorConfig}>
        <div className="editor-container">
          <div className="editor-inner">
            <RichTextPlugin
              contentEditable={<ContentEditable className="editor-input" />}
              placeholder={<Placeholder>Nothing to see here...</Placeholder>}
              ErrorBoundary={LexicalErrorBoundary}
            />
            <InitialContentPlugin value={props.initialContent} />
          </div>
        </div>
      </LexicalComposer>
    );
  }

  return (
    <LexicalComposer initialConfig={editorConfig}>
      <div className="editor-container">
        {toolbar && <ToolbarPlugin />}
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
          <InitialContentPlugin value={props.initialContent} />
        </div>
      </div>
    </LexicalComposer>
  );
}

export default RichTextEditor;

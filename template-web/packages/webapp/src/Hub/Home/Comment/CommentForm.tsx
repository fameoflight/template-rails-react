import React from 'react';
import { graphql, useFragment } from 'react-relay/hooks';

import { CommentForm_record$key } from '@picasso/fragments/src/CommentForm_record.graphql';
import { CommentForm_user$key } from '@picasso/fragments/src/CommentForm_user.graphql';

import _ from 'lodash';

import { CommentOutlined } from '@ant-design/icons';
import { Avatar, Button, Form, Input, Rate, Select } from 'antd';
import { useForm } from 'antd/lib/form/Form';
import RichTextJsonInput from '@picasso/shared/src/RichTextEditor/RichTextJsonInput';

const fragmentSpec = graphql`
  fragment CommentForm_record on Comment {
    id
    tags
    richTextContent {
      content
      contentHtml
      format
    }
  }
`;

const userFragmentSpec = graphql`
  fragment CommentForm_user on User {
    id
    name
    avatar {
      url
    }
  }
`;

interface ICommentFormProps {
  user: CommentForm_user$key;
  defaultTags?: string[];
  record: CommentForm_record$key | null;
  onSubmit: (values: any) => void;
  showRating: boolean;
}

const CommentForm = (props: ICommentFormProps): any => {
  const [form] = useForm();

  const user = useFragment(userFragmentSpec, props.user);
  const record = useFragment(fragmentSpec, props.record);

  const onFinish = (values) => {
    props.onSubmit?.(values);

    form.resetFields();
  };

  const onFinishFailed = (errorInfo) => {
    console.log('Failed:', errorInfo);
  };

  const allTags = _.uniq([
    ...(record?.tags || []),
    ...(props.defaultTags || []),
  ]);

  const tagOptions = allTags.map((tag) => ({
    label: tag,
    value: tag,
  }));

  return (
    <div className="flex items-start space-x-4 w-full">
      <div className="flex-shrink-0">
        <Avatar
          src={user.avatar?.url}
          style={{ color: '#1677ff', backgroundColor: '#D0E8FF' }}
        >
          {user.name?.[0]}
        </Avatar>
      </div>

      <Form
        preserve={false}
        form={form}
        layout="vertical"
        onFinish={onFinish}
        name="CommentForm"
        className="min-w-0 flex-1"
        onFinishFailed={onFinishFailed}
      >
        <Form.Item name="id" hidden initialValue={record?.id}>
          <Input />
        </Form.Item>

        {props.showRating && (
          <Form.Item name="rating" rules={[{ required: true }]}>
            <Rate allowClear allowHalf />
          </Form.Item>
        )}

        <Form.Item
          name="richTextContent"
          initialValue={record?.richTextContent}
        >
          <RichTextJsonInput />
        </Form.Item>

        {props.defaultTags && (
          <Form.Item name="tags" initialValue={record?.tags}>
            <Select
              mode="tags"
              placeholder="Tags"
              style={{ width: '100%' }}
              options={tagOptions}
            />
          </Form.Item>
        )}

        <div className="mt-4 space-x-4">
          <Button type="primary" htmlType="submit">
            <CommentOutlined /> Submit Comment
          </Button>
        </div>
      </Form>
    </div>
  );
};

export default CommentForm;

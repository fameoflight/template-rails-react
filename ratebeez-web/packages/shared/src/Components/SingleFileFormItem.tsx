import React from 'react';

import _ from 'lodash';

import { InboxOutlined } from '@ant-design/icons';
import { Button, Form } from 'antd';
import Upload, { RcFile } from 'antd/lib/upload';

import AttachmentView, { AttachmentType } from './AttachmentView';

function DefaultInnerView({
  mode,
}: {
  mode: ISingleFileFormItemProps['mode'];
}) {
  if (mode === 'button') {
    return <Button icon={<InboxOutlined />}>Upload</Button>;
  }
  return (
    <>
      <p className="ant-upload-drag-icon">
        <InboxOutlined />
      </p>
      <p className="ant-upload-text">
        Click or drag file to this area to upload
      </p>
    </>
  );
}

export type UploadProps = {
  fileSizeLimitMB: number;
  accept?: string;
};

interface ISingleFileFormItemProps {
  uploadProps: UploadProps;
  attachmentProps: {
    name: string;
    attachment?: null | AttachmentType;
  };
  label?: string;
  name: string;
  required?: boolean;
  innerView?: React.ReactNode;
  mode?: 'button' | 'dragger';
  className?: string;
  help?: React.ReactNode;
  valueType?: 'string' | 'file';
  onChange?: (file: File | null, content: string | ArrayBuffer | null) => void;
}

const SingleFileFormItem = (props: ISingleFileFormItemProps) => {
  const mode = props.mode || 'dragger';

  const UploadComponent = mode == 'button' ? Upload : Upload.Dragger;

  const fileSizeLimit = props.uploadProps.fileSizeLimitMB * 1024 * 1024;

  const attachment = props.attachmentProps?.attachment;

  const valueType = props.valueType || 'file';

  const normFile = (e: any) => {
    if (Array.isArray(e)) {
      return e;
    }
    return e && e.fileList;
  };

  const innerView = props.innerView || <DefaultInnerView mode={mode} />;

  return (
    <>
      <Form.Item name={props.name} hidden>
        <div />
      </Form.Item>

      <Form.Item
        name="_internal_files_"
        label={props.label}
        valuePropName="fileList"
        getValueFromEvent={normFile}
        required={props.required}
        className={props.className}
        help={props.help}
        rules={[
          ({ getFieldValue, setFieldsValue }) => ({
            validator(_rule, value) {
              const file: File | null = _.get(
                _.first(value),
                'originFileObj'
              ) as any as File | null;

              if (file) {
                const fileSizeMB = file.size / 1024 / 1024;
                const isSizeValid = file.size < fileSizeLimit;

                if (!isSizeValid) {
                  return Promise.reject(
                    new Error(
                      `File size limit ${props.uploadProps.fileSizeLimitMB} MB, current file ${fileSizeMB} MB`
                    )
                  );
                }

                if (valueType === 'file') {
                  setFieldsValue({ [props.name]: file });
                  props.onChange?.(file, null);
                } else {
                  const fileReader = new FileReader();
                  fileReader.onload = (e) => {
                    if (e.target?.readyState === FileReader.DONE) {
                      setFieldsValue({ [props.name]: e.target.result });
                      props.onChange?.(file, e.target.result);
                    }
                  };
                  fileReader.readAsText(file);
                }
              } else if (!attachment?.url) {
                props.onChange?.(null, null);
                if (props.required) {
                  return Promise.reject(
                    new Error(`${props.attachmentProps.name} is required`)
                  );
                }
              }

              return Promise.resolve();
            },
          }),
        ]}
      >
        <UploadComponent
          accept={props.uploadProps.accept}
          name="files"
          multiple={false}
          maxCount={1}
          beforeUpload={() => false}
        >
          {innerView}
        </UploadComponent>
      </Form.Item>

      <AttachmentView
        name={props.attachmentProps?.name || 'Attachment'}
        attachment={attachment}
        className="mt-4"
      />
    </>
  );
};

export default SingleFileFormItem;

import React, { useState } from 'react';

import uploadFile from '@picasso/shared/src/utils/files/upload';

import _ from 'lodash';

import { PlusOutlined } from '@ant-design/icons';
import { Spin, Upload, message } from 'antd';

interface IAvatarUploaderProps {
  src: string | null | undefined;
  fileSizeMb: number;
  onUpdate: (signedId: string) => void;
}

function AvatarUploader(props: IAvatarUploaderProps) {
  const [loading, setLoading] = useState(false);

  const beforeUpload = (file) => {
    const imageExtensions = ['image/jpeg', 'image/png'];
    const isImage = _.includes(imageExtensions, file.type);
    if (!isImage) {
      message.error('You can only upload JPG or PNG file!');
    }

    const isSizeValid = file.size / 1024 / 1024 < props.fileSizeMb;
    if (!isSizeValid) {
      message.error('Image must smaller than 2MB!');
    }

    return isImage && isSizeValid;
  };

  const newUploadImage = async (options) => {
    const { onSuccess, onError, file, onProgress } = options;

    setLoading(true);

    uploadFile({ file })
      .then((data) => {
        onSuccess('ok');
        if (data?.signedId) {
          props.onUpdate(data?.signedId);
        }
        setLoading(false);
      })
      .catch((error) => {
        onError(error);
        console.error('upload error', error);
        setLoading(false);
      });
  };

  const uploadButton = (
    <div>
      <PlusOutlined />
      <div className="mt-2">Upload</div>
    </div>
  );

  const display = props.src ? (
    <img src={props.src} alt="avatar" className="object-fill w-full" />
  ) : (
    uploadButton
  );

  return (
    <Upload
      accept=".jpg,.jpeg,.png"
      name="avatar"
      listType="picture-card"
      customRequest={newUploadImage}
      showUploadList={false}
      beforeUpload={beforeUpload}
    >
      {loading ? <Spin size="large" /> : display}
    </Upload>
  );
}

export default AvatarUploader;

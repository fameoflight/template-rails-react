import { graphql } from 'relay-runtime';

import {
  CreateDirectUploadInput,
  uploadFileMutation,
  uploadFileMutation$data,
} from '@picasso/fragments/src/uploadFileMutation.graphql';

import { commitCompatMutation } from '@picasso/shared/src/relay/hooks';

import { BlobUpload } from '@rails/activestorage/src/blob_upload';
import { FileChecksum } from '@rails/activestorage/src/file_checksum';

import { invariant } from '../index';

function calculateChecksum(file) {
  return new Promise<string>((resolve, reject) => {
    FileChecksum.create(file, (error, checksum) => {
      if (error) {
        reject(error);
        return;
      }

      resolve(checksum);
    });
  });
}

const getFileMetadata = (file: File) =>
  new Promise<CreateDirectUploadInput>((resolve, reject) => {
    calculateChecksum(file)
      .then((checksum) => {
        resolve({
          checksum,
          filename: file.name,
          contentType: file.type,
          byteSize: file.size,
        });
      })
      .catch((error) => reject(error));
  });

type FileMutationData = NonNullable<
  uploadFileMutation$data['createDirectUpload']
>['directUpload'];

function createDirectUpload(
  input: CreateDirectUploadInput,
  onError: (error) => void,
  onCompleted: (uploadFileMutation, payloadError) => void
) {
  commitCompatMutation<uploadFileMutation>({
    mutation: graphql`
      mutation uploadFileMutation($input: CreateDirectUploadInput!) {
        createDirectUpload(input: $input) {
          errors
          directUpload {
            id
            signedId
            publicUrl
            directUploadHeaders
            directUploadUrl
          }
        }
      }
    `,
    variables: { input },
    onCompleted,
    onError,
  });
}

const createUploadParams = (file: File) =>
  new Promise<FileMutationData>((resolve, reject) => {
    getFileMetadata(file)
      .then((attributes) => {
        createDirectUpload(
          attributes,
          (error) => {
            reject(error);
          },
          (response, error) => {
            const directUpload = response.createDirectUpload?.directUpload;

            if (directUpload) {
              resolve(directUpload);
            } else {
              reject(error);
            }
          }
        );
      })
      .catch((error) => reject(error));
  });

const directUpload = (data: FileMutationData, file: File) => {
  const upload = new BlobUpload({
    file,
    directUploadData: {
      url: data.directUploadUrl,
      headers: data.directUploadHeaders,
    },
  });
  return new Promise<FileMutationData>((resolve, reject) => {
    upload.create((error) => {
      if (error) {
        reject(error);
      } else {
        resolve(data);
      }
    });
  });
};

// TODO: hemantv: add progress events
interface IUploadFile {
  file?: File;
  onProgress?: (percent: number) => void;
}

const uploadFile = async (props: IUploadFile) => {
  const file = props.file;

  if (!file) {
    return null;
  }

  return new Promise<FileMutationData>((resolve, reject) => {
    invariant(!!props.file, 'file is null');

    createUploadParams(file)
      .then((data) => {
        directUpload(data, file)
          .then(() => {
            resolve(data);
          })
          .catch((error) => reject(error));
      })
      .catch((error) => reject(error));
  });
};

export default uploadFile;

import {
  FileExcelTwoTone,
  FileImageTwoTone,
  FilePdfTwoTone,
  FilePptTwoTone,
  FileTextTwoTone,
  FileUnknownTwoTone,
  FileWordTwoTone,
  FileZipTwoTone,
} from '@ant-design/icons';

export function iconClassFromContentType(contentTypeAny?: string | null) {
  let IconClass: typeof FileWordTwoTone | null = null;

  const contentType = (contentTypeAny || '').toLowerCase();

  if (contentType.includes('image')) {
    IconClass = FileImageTwoTone;
  }

  if (contentType.includes('pdf')) {
    IconClass = FilePdfTwoTone;
  }
  if (contentType.includes('word')) {
    IconClass = FileWordTwoTone;
  }

  if (contentType.includes('excel') || contentType.includes('spreadsheet')) {
    IconClass = FileExcelTwoTone;
  }

  if (contentType.includes('powerpoint')) {
    IconClass = FilePptTwoTone;
  }

  if (contentType.includes('zip')) {
    IconClass = FileZipTwoTone;
  }

  if (contentType.includes('text')) {
    IconClass = FileTextTwoTone;
  }

  if (!IconClass) {
    console.warn(`Unknown content type: ${contentType}`);
  }

  return IconClass || FileUnknownTwoTone;
}

import React from 'react';

import { createFromIconfontCN } from '@ant-design/icons';

// project
// https://www.iconfont.cn/manage/index?manage_type=myprojects&projectId=3421459

const IconFontCN = createFromIconfontCN({
  scriptUrl: '//at.alicdn.com/t/font_3421459_uwyc90zrss.js',
});

interface IIconFontProps {
  type: 'document' | 'location' | 'flavor' | 'signature' | 'role';
}

function IconFont({ type }: IIconFontProps) {
  return <IconFontCN type={type} />;
}

export default IconFont;

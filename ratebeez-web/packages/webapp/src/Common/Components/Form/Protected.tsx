import React, { useState } from 'react';

import _ from 'lodash';

import { Input, Select } from 'antd';

import ImageUrlInput from 'src/Common/Components/Form/ImageUrlInput';
import withProtected from 'src/Common/Components/Form/withProtected';

const Protected = {
  Input: withProtected(Input),
  Select: withProtected(Select),
  ImageUrlInput: withProtected(ImageUrlInput),
};

export default Protected;

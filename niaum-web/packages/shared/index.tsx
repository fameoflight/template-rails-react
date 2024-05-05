import { ConfigProvider } from 'antd';
import { Theme } from 'antd/lib/config-provider/context';

import './css/index.css';

export function initTheme(theme?: Theme) {
  const newTheme = theme || {
    primaryColor: '#1677ff',
  };

  ConfigProvider.config({
    theme: newTheme,
  });
}

export default {};

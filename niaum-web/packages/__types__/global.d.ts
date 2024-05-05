declare const PresetStatusColorTypes: [
  'success',
  'processing',
  'error',
  'default',
  'warning'
];

declare const PresetColorTypes: [
  'pink',
  'red',
  'yellow',
  'orange',
  'cyan',
  'green',
  'blue',
  'purple',
  'geekblue',
  'magenta',
  'volcano',
  'gold',
  'lime'
];

type AntColorType =
  | typeof PresetColorTypes[number]
  | typeof PresetStatusColorTypes[number];

declare global {
  type RelayNode = {
    id: string;
  };

  type Recordable = string | number;

  type TagColor = AntColorType;

  type TailwindColor =
    | 'picasso-primary'
    | 'indigo'
    | 'red'
    | 'green'
    | 'yellow'
    | 'gray';

  type TailwindSize = 'sm' | 'md' | 'lg' | 'xl' | 'xxl';
}

export {};

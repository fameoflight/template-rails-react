type Function<T> = (...args: any[]) => T;

type Writeable<T> = { -readonly [P in keyof T]-?: T[P] };
type DeepWriteable<T> = { -readonly [P in keyof T]: DeepWriteable<T[P]> };

declare module '*.svg';

declare module '*.png';

declare module '*.jpg';

type RelayConnections<T> = {
  readonly edges:
    | ReadonlyArray<
        | {
            readonly node?: T | null;
          }
        | null
        | undefined
      >
    | null
    | undefined;
};
export type NoRefs<T> =
  T extends Record<string, unknown>
    ? Omit<T, ' $fragmentType' | ' $fragmentRefs'>
    : T;

type RelayEdgeType<T extends RelayConnections<any>> = NonNullable<
  NonNullable<NonNullable<T['edges']>[0]>
>;
declare global {
  type RelayEdgeNode<T extends RelayConnections<any>> = NonNullable<
    RelayEdgeType<T>['node']
  >;

  namespace NodeJS {
    interface ProcessEnv {
      readonly NODE_ENV:
        | 'development'
        | 'production'
        | 'test'
        | null
        | undefined;
    }
  }
}

declare module '*.svg' {
  import * as React from 'react';

  export const ReactComponent: React.FunctionComponent<
    React.SVGProps<SVGSVGElement> & { title?: string }
  >;

  const src: string;
  export default src;
}

export {};

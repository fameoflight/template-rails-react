export interface IFlowRoute {
  path: string;
  title: string;
  description?: string;
  element: React.ReactNode;
  hideSteps?: boolean;
  navigation?: boolean;
}

export interface IReactRouterFlowRoute {
  path: string;
  flowTitle: string;
  flowDescription?: string;
  element: React.ReactNode;
  hideSteps?: boolean;
  navigation?: boolean;
}

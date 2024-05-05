import React from 'react';

interface IListComponentViewProps {
  title: string;
  description?: React.ReactNode | null;
  children?: React.ReactNode;
  actions?: React.ReactNode;
}

function ListComponentView(props: IListComponentViewProps) {
  return (
    <div className="my-2 bg-white overflow-hidden shadow">
      <div className="p-4">{props.title}</div>

      {props.description && (
        <div className="bg-gray-50 p-4">{props.description}</div>
      )}

      {props.children && (
        <div className="bg-gray-50 px-4">{props.children}</div>
      )}
      {props.actions && (
        <div className="py-4 sm:px-6">
          <div className="flex justify-end">{props.actions}</div>
        </div>
      )}
    </div>
  );
}

export default ListComponentView;

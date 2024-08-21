import React from 'react';
import { DeleteOutlined } from '@ant-design/icons';
import { classNames } from '@picasso/shared/src/utils';

export type GridItemType = {
  id: string | 'new';
  name: string;
  iconUrl?: string;
};

interface IGridItemViewProps<T extends GridItemType> {
  record: T;
  onClick?: (record: T) => void;
  onDelete?: (record: T) => void;
  size?: 'small' | 'default';
  tag?: {
    name: string;
    className: string;
  };
}

function GridItem<T extends GridItemType>(props: IGridItemViewProps<T>) {
  const { record, onClick, onDelete, size = 'default', tag } = props;
  const { name, iconUrl } = record;

  const handleClick = (e: React.MouseEvent) => {
    if (onClick && !e.defaultPrevented) {
      onClick(record);
    }
  };

  const handleDelete = (e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();
    if (onDelete) {
      onDelete(record);
    }
  };

  const showDelete = record.id !== 'new' && onDelete;

  return (
    <div
      onClick={handleClick}
      key={record.id}
      className={classNames(
        size === 'default' ? 'w-32 py-4 px-2' : 'w-24 py-2 px-1',
        'relative shadow-sm bg-white m-4 text-center items-center hover:opacity-80 hover:bg-gray-50 cursor-pointer'
      )}
    >
      {tag && (
        <div
          className={`absolute -top-2 -left-2 shadow-md px-2 uppercase ${tag.className}`}
        >
          {tag.name}
        </div>
      )}
      {showDelete && (
        <button
          className="absolute top-1 right-1 w-6 h-6 flex items-center justify-center rounded-full bg-white shadow-sm border border-gray-200 text-gray-400 hover:text-red-600 hover:bg-red-50 hover:border-red-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 transition-colors duration-200"
          onClick={handleDelete}
          aria-label="Delete item"
        >
          <DeleteOutlined style={{ fontSize: '12px' }} />
        </button>
      )}

      {iconUrl && (
        <img
          src={iconUrl}
          alt={name || 'Workflow'}
          className="w-14 h-14 object-contain mx-auto"
        />
      )}

      {size === 'small' ? (
        <div className="text-xs text-gray-400 mt-2">{name}</div>
      ) : (
        <div className="text-center mt-4">
          <h4 className="text-xs text-gray-700">{name}</h4>
        </div>
      )}
    </div>
  );
}

export default GridItem;

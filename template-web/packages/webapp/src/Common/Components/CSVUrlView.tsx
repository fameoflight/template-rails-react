import React, { useState, useEffect } from 'react';
import _ from 'lodash';
import Papa from 'papaparse';
import BaseTable, { Column } from 'react-base-table';
import 'react-base-table/styles.css';
import Errors from '@picasso/shared/src/Components/Errors';

interface ICSVUrlViewProps {
  url: string;
  width?: number;
  height?: number;
}

function CSVUrlView(props: ICSVUrlViewProps) {
  const [data, setData] = useState<any[]>([]);
  const [dataColumns, setDataColumns] = useState<any[]>([]);

  const [errors, setErrors] = useState<string[]>([]);

  useEffect(() => {
    Papa.parse(props.url, {
      download: true,
      header: true,
      complete: (results) => {
        const columns = _.map(results.meta.fields, (field) => ({
          key: field,
          title: field,
          dataKey: field,
          width: 200,
        }));

        setDataColumns(columns);
        setData(results.data);
        setErrors(results.errors.map((error) => error.message));
      },
    });
  }, [props.url]);

  const width = props.width || 800;
  const height = props.height || 400;

  return (
    <>
      <Errors errors={errors} />
      <BaseTable data={data} width={width} height={height}>
        {dataColumns.map((column) => (
          <Column
            key={column.key}
            dataKey={column.dataKey}
            width={column.width}
            title={column.title}
          />
        ))}
      </BaseTable>
    </>
  );
}

export default CSVUrlView;

import _ from 'lodash';

const csv = {
  isValid: (lines: string[]) => {
    const firstLine = _.first(lines);

    if (!firstLine) {
      return false;
    }

    const size = csv.splitLine(firstLine).length;

    return _.every(lines, (line) => {
      return csv.splitLine(line).length === size;
    });
  },
  splitLine(line: string) {
    const parts = line.split(/,(?=(?:(?:[^"]*"){2})*[^"]*$)/);

    return _.map(parts, (part) => {
      return _.trim(part, '" ');
    });
  },

  selectColumns(lines: string[], columns: number[]) {
    return _.map(lines, (line) => {
      const columnsInLine = csv.splitLine(line);

      return _.map(columns, (column) => columnsInLine[column]);
    });
  },
  selectColumn(lines: string[], column?: number) {
    if (column === undefined) {
      return [];
    }

    return _.map(lines, (line) => {
      const columnsInLine = csv.splitLine(line);

      return columnsInLine[column];
    });
  },
};

export default csv;

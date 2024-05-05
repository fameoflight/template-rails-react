import React from 'react';

import { CloseOutlined } from '@ant-design/icons';
import { Button, DatePicker } from 'antd';
import { PickerDateProps } from 'antd/lib/date-picker/generatePicker';

import moment, { Moment } from 'moment';

interface IDateTimePickerProps
  extends Omit<PickerDateProps<Moment>, 'picker' | 'onChange' | 'value'> {
  value?: string;
  onChange?: (value: string | null) => void;
}

function DateTimePicker(props: IDateTimePickerProps) {
  const { value, onChange, allowClear, ...rest } = props;

  const [date, setDate] = React.useState(value ? moment(value) : null);

  const [time, setTime] = React.useState(value ? moment(value) : null);

  const onValueChange = () => {
    const dateString = (date || moment()).format('YYYY-MM-DD');

    const timeString = (time || moment()).format('HH:mm:ss');

    onChange?.(`${dateString}T${timeString}${moment().format('Z')}`);
  };

  const onChangeDate = (date, _dateString) => {
    setDate(date);
    if (!time) {
      setTime(moment());
    }
    onValueChange();
  };

  const onChangeTime = (time, _timeString) => {
    setTime(time);
    if (!date) {
      setDate(moment());
    }
    onValueChange();
  };

  return (
    <div className="inline">
      <DatePicker
        {...rest}
        value={date}
        onChange={onChangeDate}
        allowClear={false}
      />

      <DatePicker.TimePicker
        {...rest}
        className="ml-2"
        value={time}
        onChange={onChangeTime}
        format="HH:mm:ss"
        allowClear={false}
      />

      {allowClear && (
        <Button
          className="ml-2"
          type="text"
          onClick={() => {
            setDate(null);
            setTime(null);
            onChange?.(null);
          }}
        >
          <CloseOutlined />
        </Button>
      )}
    </div>
  );
}

export default DateTimePicker;

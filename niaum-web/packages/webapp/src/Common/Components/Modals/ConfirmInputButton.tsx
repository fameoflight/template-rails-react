import React, { useState } from 'react';

import { Button, ButtonProps, Input, Modal, ModalProps, Tooltip } from 'antd';

interface IConfirmInputButtonProps extends ButtonProps {
  confirmText: string;
  helpElement?: JSX.Element;
  tooltip?: React.ReactNode;
  modalProps?: ModalProps;
}
function ConfirmInputButton(props: IConfirmInputButtonProps) {
  const {
    confirmText,
    children,
    onClick,
    helpElement,
    modalProps,
    tooltip,
    ...restProps
  } = props;

  const [modalOpen, setModalOpen] = useState(false);

  const [inputValue, setInputValue] = useState<string>('');

  const onButtonClick = () => {
    if (onClick) {
      setModalOpen(true);
    }
  };

  return (
    <span>
      <Tooltip title={tooltip} color="orange">
        <Button {...restProps} onClick={onButtonClick}>
          {children}
        </Button>
      </Tooltip>

      <Modal
        title="Confirm"
        okText="Confirm"
        {...modalProps}
        open={modalOpen}
        okButtonProps={{
          ...modalProps?.okButtonProps,
          danger: modalProps?.okButtonProps?.danger || restProps.danger,
          disabled: inputValue !== confirmText,
        }}
        onOk={(e) => {
          onClick?.(e);
          setModalOpen(false);
        }}
        onCancel={() => {
          setModalOpen(false);
          setInputValue('');
        }}
      >
        {helpElement}

        <p className="my-4">
          Please type <code className="bg-gray-200 p-1">{confirmText}</code> to
          confirm
        </p>

        <Input
          placeholder={`Type ${confirmText} to confirm`}
          onChange={(e) => {
            setInputValue(e.target.value);
          }}
        />
      </Modal>
    </span>
  );
}

export default ConfirmInputButton;

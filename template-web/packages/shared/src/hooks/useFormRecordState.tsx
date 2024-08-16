import React, { useState } from 'react';

export const newRecord = { id: null };

function useFormRecordState<T>(initialState: T | null | { id: null }) {
  return useState<T | null | { id: null }>(initialState);
}

export default useFormRecordState;

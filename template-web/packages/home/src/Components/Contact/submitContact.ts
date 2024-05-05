import api from '@picasso/shared/src/api';

import axios from 'axios';

function contactSubmit(values: any) {
  const demoUrl = `${api.basePath()}/api/demos`;

  return new Promise((resolve, reject) => {
    axios
      .post(demoUrl, {
        name: values.name,
        email: values.email,
        company_name: values.companyName,
        comment: values.comment,
      })
      .then((data) => {
        resolve(data);
      })
      .catch((error) => {
        reject(error);
      });
  });
}

export default contactSubmit;

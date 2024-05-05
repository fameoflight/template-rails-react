import React from 'react';

import { EnvelopeIcon, PhoneIcon } from '@heroicons/react/24/outline';
import { Spin } from 'antd';

import ContactForm from 'src/Components/Contact/ContactForm';
import ResponseView from 'src/Components/Contact/ResponseView';
import contactSubmit from 'src/Components/Contact/submitContact';

export default function Contact() {
  const [loading, setLoading] = React.useState(false);

  const [submitted, setSubmitted] = React.useState(false);

  const onSubmit = (values) => {
    setLoading(true);

    contactSubmit(values)
      .then(() => {
        setSubmitted(true);

        setLoading(false);
      })
      .catch(() => {
        setSubmitted(false);
        setLoading(false);
      });
  };
  return (
    <div className="relative bg-white">
      <div className="absolute inset-0">
        <div className="absolute inset-y-0 left-0 w-1/2 bg-gray-50" />
      </div>
      <div className="relative mx-auto max-w-7xl lg:grid lg:grid-cols-5">
        <div className="bg-gray-50 py-16 px-4 sm:px-6 lg:col-span-2 lg:px-8 lg:py-24 xl:pr-12">
          <div className="mx-auto max-w-lg">
            <h2 className="text-2xl font-bold tracking-tight text-gray-900 sm:text-3xl">
              Let&#39;s work together
            </h2>
            <p className="mt-3 text-lg leading-6 text-gray-500">
              We&#39;re here to help you get started with Picasso. Fill out the
              form and we&#39;ll be in touch shortly.
            </p>
            <dl className="mt-8 text-base text-gray-500">
              <div>
                <dt className="sr-only">Postal address</dt>
                <dd>
                  <p>1 Embarcadero St</p>
                  <p>San Francisco, CA 94607</p>
                </dd>
              </div>
              <div className="mt-6">
                <dt className="sr-only">Phone number</dt>
                <dd className="flex">
                  <PhoneIcon
                    className="h-6 w-6 flex-shrink-0 text-gray-400"
                    aria-hidden="true"
                  />
                  <span className="ml-3">+1 (415) 355-4946</span>
                </dd>
              </div>
              <div className="mt-3">
                <dt className="sr-only">Email</dt>
                <dd className="flex">
                  <EnvelopeIcon
                    className="h-6 w-6 flex-shrink-0 text-gray-400"
                    aria-hidden="true"
                  />
                  <span className="ml-3">hemant@usepicasso.com</span>
                </dd>
              </div>
            </dl>
          </div>
        </div>
        <div className="bg-white py-16 px-4 sm:px-6 lg:col-span-3 lg:px-8 xl:pl-12">
          <div className="mx-auto max-w-lg lg:max-w-none">
            <Spin spinning={loading}>
              {submitted ? (
                <ResponseView />
              ) : (
                <ContactForm onSubmit={onSubmit} submitText="Learn More" />
              )}
            </Spin>
          </div>
        </div>
      </div>
    </div>
  );
}

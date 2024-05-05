import React from 'react';

export default function Stats() {
  return (
    <div className="bg-picasso-primary-800 py-24">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="mx-auto max-w-4xl text-center">
          <h2 className="text-3xl font-bold tracking-tight text-white sm:text-4xl">
            Trusted by over 100+ companies worldwide
          </h2>
          <p className="mt-3 text-xl text-picasso-primary-200 sm:mt-4">
            Picasso is used by companies of all sizes, from startups to Fortune
            500
          </p>
        </div>
        <dl className="mt-10 text-center sm:mx-auto sm:grid sm:max-w-3xl sm:grid-cols-3 sm:gap-8">
          <div className="flex flex-col">
            <dt className="order-2 mt-2 text-lg font-medium leading-6 text-picasso-primary-200">
              Automated Checks
            </dt>
            <dd className="order-1 text-5xl font-bold tracking-tight text-white">
              100,000
            </dd>
          </div>
          <div className="mt-10 flex flex-col sm:mt-0">
            <dt className="order-2 mt-2 text-lg font-medium leading-6 text-picasso-primary-200">
              Integrations
            </dt>
            <dd className="order-1 text-5xl font-bold tracking-tight text-white">
              40+
            </dd>
          </div>
          <div className="mt-10 flex flex-col sm:mt-0">
            <dt className="order-2 mt-2 text-lg font-medium leading-6 text-picasso-primary-200">
              Hours Saved
            </dt>
            <dd className="order-1 text-5xl font-bold tracking-tight text-white">
              1000+
            </dd>
          </div>
        </dl>
      </div>
    </div>
  );
}

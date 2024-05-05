import React, { Fragment } from 'react';

import Image from 'next/image';

import controlsImage from 'src/images/controls.png';

const navigation = [
  { name: 'Product', href: '#' },
  { name: 'Features', href: '#' },
  { name: 'Marketplace', href: '#' },
  { name: 'Company', href: '#' },
];

export default function Example() {
  return (
    <div className="bg-gray-50">
      <div className="relative overflow-hidden">
        <div className="relative pt-6 pb-16 sm:pb-24">
          <div className="mx-auto mt-16 max-w-7xl px-4 sm:mt-24 sm:px-6">
            <div className="text-center">
              <h1 className="text-4xl  md:text-5xl font-bold tracking-tight text-gray-900">
                <span className="block">Automate compliance</span>
                <span className="block text-picasso-primary-900 text-3xl">
                  build trust with customers
                </span>
              </h1>
              <p className="mx-auto mt-3 max-w-md text-base text-gray-500 sm:text-lg md:mt-5 md:max-w-3xl md:text-xl">
                Picasso simplifies the complex, time-consuming, and tedious
                process of becoming SOC 2, HIPAA, or ISO 27001 compliant. So you
                can focus on growing your business.
              </p>
            </div>
          </div>
        </div>

        <div className="relative">
          <div className="absolute inset-0 flex flex-col" aria-hidden="true">
            <div className="flex-1" />
            <div className="w-full flex-1 bg-gray-800" />
          </div>
          <div className="mx-auto max-w-7xl px-4 sm:px-6">
            <Image
              className="relative rounded-lg shadow-lg"
              src={controlsImage}
              alt="App screenshot"
            />
          </div>
        </div>
      </div>
      <div className="bg-gray-800">
        <div className="mx-auto max-w-7xl py-16 px-4 sm:py-24 sm:px-6 lg:px-8"></div>
      </div>
    </div>
  );
}

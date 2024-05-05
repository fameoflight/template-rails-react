import React from 'react';

import Image from 'next/future/image';

import sfMapImg from 'src/images/SFmap.png';

function AboutCTA() {
  return (
    <div className="grow py-16 bg-picasso-primary-900">
      <div className="max-w-7xl mx-auto py-16 px-4 sm:px-6 lg:px-8">
        <div className="bg-picasso-primary-800 shadow-xl overflow-hidden lg:grid lg:grid-cols-2 lg:gap-4">
          <div className="pt-10 pb-12 px-6 sm:pt-16 sm:px-16 lg:py-16 lg:pr-0 xl:py-20 xl:px-20">
            <div className="lg:self-center">
              <h2 className="text-3xl font-extrabold text-white sm:text-4xl">
                <span className="block">Built in San Francisco</span>
              </h2>
              <p className="mt-4 text-lg leading-6 text-picasso-primary-200">
                Reach out to us to learn more about Picasso
              </p>
              <a
                href="mailto:founders@usepicasso.com"
                target="_blank"
                className="mt-8 bg-white border border-transparent rounded-md shadow px-5 py-3 inline-flex items-center text-base font-medium text-picasso-primary-800 hover:bg-picasso-primary-50"
                rel="noreferrer"
              >
                Contact Us
              </a>
            </div>
          </div>
          <div className="-mt-6 aspect-w-5 aspect-h-3 md:aspect-w-2 md:aspect-h-1">
            <Image
              className="transform translate-x-6 translate-y-6 rounded-md object-cover object-left-top sm:translate-x-16 lg:translate-y-20"
              src={sfMapImg}
              alt="App screenshot"
            />
          </div>
        </div>
      </div>
    </div>
  );
}

export default AboutCTA;

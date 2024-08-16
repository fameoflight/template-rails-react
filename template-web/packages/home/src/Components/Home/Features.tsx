import React from 'react';

import {
  BoltIcon,
  GlobeAltIcon,
  ScaleIcon,
  ShieldCheckIcon,
} from '@heroicons/react/24/outline/esm/index.js';

const features = [
  {
    name: 'Integrations',
    description: `40+ integrations gives you visibility into your compliance status and control across your security program.`,
    icon: GlobeAltIcon,
  },
  {
    name: 'Automated Evidence Collection',
    description: `No more manual evidence collection. Picasso automates the collection of evidence for your compliance program.`,
    icon: ScaleIcon,
  },
  {
    name: 'Compliance Monitoring',
    description:
      'Continuous, automated monitoring of the compliance status of company assets eliminates the repetitive manual work of compliance.',
    icon: BoltIcon,
  },
  {
    name: 'Actionable Insights',
    description:
      'Gain visibility into your security posture and control over your compliance.',
    icon: ShieldCheckIcon,
  },
];

export default function Features() {
  return (
    <div className="bg-white py-12">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="lg:text-center">
          <p className="mt-2 text-3xl font-bold leading-8 tracking-tight text-gray-900 sm:text-4xl">
            A better way to work with your clients
          </p>
        </div>

        <div className="my-12 mt-24">
          <dl className="space-y-10 md:grid md:grid-cols-2 md:gap-x-8 md:gap-y-10 md:space-y-0">
            {features.map((feature) => (
              <div key={feature.name} className="relative">
                <dt>
                  <div className="absolute flex h-12 w-12 items-center justify-center rounded-md bg-picasso-primary-800 text-white">
                    <feature.icon className="h-6 w-6" aria-hidden="true" />
                  </div>
                  <p className="ml-16 text-lg font-medium leading-6 text-gray-900">
                    {feature.name}
                  </p>
                </dt>
                <dd className="mt-2 ml-16 text-base text-gray-500">
                  {feature.description}
                </dd>
              </div>
            ))}
          </dl>
        </div>
      </div>
    </div>
  );
}

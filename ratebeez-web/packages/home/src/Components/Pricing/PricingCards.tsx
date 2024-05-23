import React from 'react';

import { classNames } from '@picasso/shared/src/utils';

import { CheckIcon } from '@heroicons/react/24/solid';

export type PlanKey = 'starter' | 'scale' | 'on-premise';

export interface IPricingPlan {
  key: PlanKey;
  title: string;
  featured: boolean;
  description: string;
  features: {
    key: string | number;
    value: string;
  }[];
}

interface IPricingCardsProps {
  plans: IPricingPlan[];
  prices: Record<PlanKey, number>;
}

function PricingCards(props: IPricingCardsProps) {
  const { plans } = props;

  return (
    <div className="relative mx-auto mt-8 max-w-2xl px-4 pb-8 sm:mt-12 sm:px-6 lg:max-w-7xl lg:px-8 lg:pb-0">
      {/* Decorative background */}
      <div
        aria-hidden="true"
        className="absolute inset-0 top-4 bottom-6 left-8 right-8 hidden rounded-tl-lg rounded-tr-lg bg-picasso-primary-900 lg:block"
      />

      <div className="relative space-y-6 lg:grid lg:grid-cols-3 lg:space-y-0">
        {plans.map((plan) => (
          <div
            key={plan.title}
            className={classNames(
              plan.featured
                ? 'bg-white ring-2 ring-picasso-primary-900 shadow-md'
                : 'bg-picasso-primary-900 lg:bg-transparent',
              'pt-6 px-6 pb-3 lg:px-8 lg:pt-12'
            )}
          >
            <div>
              <h3
                className={classNames(
                  plan.featured ? 'text-picasso-primary-800' : 'text-white',
                  'text-base font-semibold'
                )}
              >
                {plan.title}
              </h3>
              <div className="flex flex-col items-start sm:flex-row sm:items-center sm:justify-between lg:flex-col lg:items-start">
                <div className="mt-3 flex items-center">
                  <p
                    className={classNames(
                      plan.featured ? 'text-picasso-primary-800' : 'text-white',
                      'text-4xl font-bold tracking-tight'
                    )}
                  >
                    {props.prices[plan.key] > 0
                      ? props.prices[plan.key]
                      : 'Custom'}
                  </p>
                  {props.prices[plan.key] > 0 && (
                    <div className="ml-4">
                      <p
                        className={classNames(
                          plan.featured ? 'text-gray-700' : 'text-white',
                          'text-lg'
                        )}
                      >
                        USD / mo
                      </p>
                    </div>
                  )}
                </div>
              </div>
            </div>
            <h4 className="sr-only">Features</h4>
            <ul
              role="list"
              className={classNames(
                plan.featured
                  ? 'border-gray-200 divide-gray-200'
                  : 'border-picasso-primary-700 divide-picasso-primary-700 divide-opacity-75',
                'mt-7 border-t divide-y lg:border-t-0'
              )}
            >
              {plan.features.map((features) => (
                <li key={features.key} className="flex items-center py-3">
                  <CheckIcon
                    className={classNames(
                      plan.featured
                        ? 'text-picasso-primary-700'
                        : 'text-picasso-primary-200',
                      'w-5 h-5 flex-shrink-0'
                    )}
                    aria-hidden="true"
                  />
                  <span
                    className={classNames(
                      plan.featured ? 'text-gray-600' : 'text-white',
                      'ml-3 text-sm font-medium'
                    )}
                  >
                    {features.value}
                  </span>
                </li>
              ))}
            </ul>
          </div>
        ))}
      </div>
    </div>
  );
}

export default PricingCards;

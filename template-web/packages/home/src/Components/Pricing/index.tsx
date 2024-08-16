import React from 'react';

import RadioCard from '@picasso/shared/src/Components/RadioCard';
import Toggle from '@picasso/shared/src/Components/Toggle';

import { Slider } from 'antd';

import PricingFAQ from './PricingFAQ';
import { calculatePrice, faqs, plans } from './data';

import PricingCards from './PricingCards';

type TermType = 'monthly' | 'yearly';

type TermOption = {
  label: string;
  value: TermType;
  descriptions: string[];
};

const termOptions: [TermOption, TermOption] = [
  {
    label: 'Monthly',
    value: 'monthly',
    descriptions: ['Pay as you go'],
  },
  {
    label: 'Yearly',
    value: 'yearly',
    descriptions: ['Save 20% with annual billing'],
  },
];

export default function Pricing() {
  const [userCount, setUserCount] = React.useState(10);

  const multiplier: Record<TermType, number> = {
    monthly: 1,
    yearly: 0.8,
  };

  const [term, setTerm] = React.useState<TermType>('monthly');

  const planPrices: any = React.useMemo(() => {
    const prices = {};

    plans.forEach((plan) => {
      prices[plan.key] = calculatePrice(plan, userCount) * multiplier[term];
    });

    return prices;
  }, [userCount, term]);

  return (
    <div className="bg-gray-50">
      <div className="relative bg-picasso-primary-800">
        {/* Overlapping background */}
        <div
          aria-hidden="true"
          className="absolute bottom-0 hidden h-6 w-full bg-gray-50 lg:block"
        />

        <div className="relative mx-auto max-w-2xl px-4 pt-16 text-center sm:px-6 sm:pt-32 lg:max-w-7xl lg:px-8">
          <h1 className="text-4xl font-bold tracking-tight text-white sm:text-6xl">
            <span className="block lg:inline">Transparent Pricing</span>
          </h1>
          <p className="mt-4 text-xl text-picasso-primary-100">
            Everything you need to get audit ready.
          </p>
        </div>

        <h2 className="sr-only">Plans</h2>
        <div className="relative mt-8 flex justify-center">
          <Toggle options={termOptions} value={term} onChange={setTerm} />
        </div>
        <div className="max-w-xl mx-auto my-12 px-8">
          <div className="text-center mb-8 text-white font-semibold text-xl">
            Number of employees
            <span className="mx-2 text-3xl">{userCount}</span>
          </div>
          <Slider
            min={10}
            max={150}
            step={1}
            value={userCount}
            onChange={(value) => setUserCount(value)}
            trackStyle={{
              backgroundColor: '#fff',
              height: 4,
            }}
            handleStyle={{
              borderColor: '#fff',
              height: 20,
              width: 20,
              marginLeft: -10,
              marginTop: -8,
              backgroundColor: '#fff',
            }}
          />
        </div>

        <PricingCards plans={plans} prices={planPrices} />
      </div>

      <PricingFAQ faqs={faqs} />
    </div>
  );
}

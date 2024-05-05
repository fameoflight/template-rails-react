import _ from 'lodash';

import { IPricingPlan } from './PricingCards';

type PricingTier = {
  to: number;
  perUserPrice: number;
};

type Plan = IPricingPlan & {
  pricingTiers: PricingTier[];
};

const LIMIT = 100;

export const plans: Plan[] = [
  {
    key: 'starter',
    title: 'Starter',
    featured: false,
    description: 'All the basics for your SOC2 Audit',
    pricingTiers: [
      {
        to: 10,
        perUserPrice: 30,
      },
      {
        to: 50,
        perUserPrice: 25,
      },
      {
        to: LIMIT,
        perUserPrice: 15,
      },
    ],
    features: [
      { key: 1, value: 'SOC2 Framework' },
      { key: 2, value: 'Automated Evidence Collection' },
      { key: 3, value: 'Policy Templates' },
      { key: 4, value: 'Builtin Helpdesk' },
    ],
  },
  {
    key: 'scale',
    title: 'Scale',
    featured: true,
    description: 'The best financial services for your thriving business.',
    pricingTiers: [
      {
        to: 10,
        perUserPrice: 50,
      },
      {
        to: 50,
        perUserPrice: 40,
      },
      {
        to: LIMIT,
        perUserPrice: 30,
      },
    ],
    features: [
      { key: 1, value: 'Everything in Starter' },
      { key: 2, value: 'Multiple Frameworks' },
      { key: 3, value: 'Multiple cloud providers' },
      { key: 4, value: 'Multiple account' },
      { key: 5, value: 'Audit Logs' },
    ],
  },
  {
    key: 'on-premise',
    title: 'On Premise',
    featured: false,
    description: 'Keep your data on your own servers.',
    pricingTiers: [
      {
        to: 10,
        perUserPrice: 0,
      },
      {
        to: 50,
        perUserPrice: 0,
      },
      {
        to: LIMIT,
        perUserPrice: 0,
      },
    ],
    features: [
      { key: 1, value: 'Everything in Scale' },
      { key: 2, value: 'On Premise' },
    ],
  },
];

export const faqs = [
  {
    key: 1,
    question: 'Do you have a free trial?',
    answer:
      'No, we do not have a free trial. We believe that you should be able to try our product before you buy it. We offer a 14 day money back guarantee.',
  },

  {
    key: 3,
    question: 'Do you provide onboarding support?',
    answer:
      'Yes, please reach out to support@usepicasso.com for more information.',
  },
  {
    key: 4,
    question: 'How many integrations do you support?',
    answer: 'Currently we support 40+ most popular integrations.',
  },
  {
    key: 6,
    question: 'Do you support multiple accounts?',
    answer:
      'Yes, we support multiple accounts. You can connect multiple accounts from the same cloud provider.',
  },
  {
    key: 5,
    question: 'Do you support multiple cloud providers?',
    answer: 'Yes, we support AWS, Azure and GCP.',
  },
];

export function calculatePrice(plan: Plan, users: number): number {
  const tiers = _.sortBy(plan.pricingTiers, 'to');

  if (users > LIMIT) {
    return 0;
  }

  let price = 0;

  let remainingUsers = users;

  for (let i = 0; i < tiers.length; i++) {
    const tier = tiers[i];

    if (remainingUsers <= tier.to) {
      price += remainingUsers * tier.perUserPrice;
      break;
    } else {
      price += tier.to * tier.perUserPrice;
      remainingUsers -= tier.to;
    }
  }

  return price;
}

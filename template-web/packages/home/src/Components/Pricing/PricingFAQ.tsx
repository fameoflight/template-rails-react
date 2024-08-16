import React from 'react';

interface IPricingFAQProps {
  faqs: {
    key: string | number;
    question: string;
    answer: string;
  }[];
}
const PricingFAQ = (props: IPricingFAQProps) => {
  const { faqs } = props;

  return (
    <div className="max-w-7xl mx-auto py-16 px-4 sm:px-6 lg:py-20 lg:px-8">
      <div className="lg:grid lg:grid-cols-3 lg:gap-8">
        <div className="space-y-4">
          <h2 className="text-3xl font-extrabold text-gray-900">
            Frequently asked questions
          </h2>
          <p className="text-lg text-gray-500">
            Can’t find the answer you’re looking for? Reach out to our{' '}
            <a
              href="mailto:support@usepicasso.com"
              className="font-medium text-picasso-primary-800 hover:text-picasso-primary-700"
            >
              customer support
            </a>{' '}
            team.
          </p>
        </div>
        <div className="mt-12 lg:mt-0 lg:col-span-2">
          <dl className="space-y-12">
            {faqs.map((faq) => (
              <div key={faq.key}>
                <dt className="text-lg leading-6 font-medium text-gray-900">
                  {faq.question}
                </dt>
                <dd className="mt-2 text-base text-gray-500">{faq.answer}</dd>
              </div>
            ))}
          </dl>
        </div>
      </div>
    </div>
  );
};

export default PricingFAQ;

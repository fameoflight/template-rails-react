import React from 'react';

const faqs = [
  {
    question: 'Where do I start?',
    answer:
      'You can start by searching for a carrier using the search bar at the top of the page.',
  },
  {
    question: 'How do I leave a review?',
    answer:
      'You can leave a review by visiting the carrier’s profile page and clicking the “Leave a Review” button.',
  },
  {
    question: 'Why I am not able to see reviews for a carrier?',
    answer:
      'In order to see reviews for a carrier, you must be active carrier.',
  },
  {
    question: 'Who is a active carrier?',
    answer:
      'A active carrier is a carrier that has posted 5 reviews in the last 30 days.',
  },
  {
    question: 'How do I contact customer support?',
    answer:
      'You can contact customer support by emailing us at support@ratebeez.com',
  },
  {
    question: 'I have a suggestion for the site, how can I submit it?',
    answer:
      'You can submit your suggestions by emailing us at support@ratebeez.com',
  },
];
function Questions() {
  return (
    <div className="bg-white">
      <div className="mx-auto max-w-7xl px-6 py-24 sm:pt-32 lg:px-8 lg:py-24">
        <div className="lg:grid lg:grid-cols-12 lg:gap-8">
          <div className="lg:col-span-5">
            <h2 className="text-2xl font-bold leading-10 tracking-tight text-gray-900">
              Frequently asked questions
            </h2>
            <p className="mt-4 text-base leading-7 text-gray-600">
              Can’t find the answer you’re looking for? Reach out to our{' '}
              <a
                href="mailto:support@ratebeez.com"
                className="font-semibold text-picasso-600 hover:text-picasso-500"
              >
                customer support
              </a>{' '}
              team.
            </p>
          </div>
          <div className="mt-10 lg:col-span-7 lg:mt-0">
            <dl className="space-y-10">
              {faqs.map((faq) => (
                <div key={faq.question}>
                  <dt className="text-base font-semibold leading-7 text-gray-900">
                    {faq.question}
                  </dt>
                  <dd className="mt-2 text-base leading-7 text-gray-600">
                    {faq.answer}
                  </dd>
                </div>
              ))}
            </dl>
          </div>
        </div>
      </div>
    </div>
  );
}

export default Questions;

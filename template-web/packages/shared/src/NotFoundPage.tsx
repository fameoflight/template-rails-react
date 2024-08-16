import React from 'react';

import TailwindButton from './Components/TailwindButton';

interface INotFoundPageProps {
  title?: string;
  subTitle?: string;
}

function NotFoundPage(props: INotFoundPageProps) {
  const title = props.title || 'Page not found';

  const subTitle =
    props.subTitle || 'The page you are looking for does not exist.';
  return (
    <div className="min-h-[90vh] bg-white px-4 py-16 sm:px-6 sm:py-24 md:grid md:place-items-center lg:px-8">
      <div className="mx-auto max-w-max">
        <main className="sm:flex">
          <p className="text-4xl font-bold tracking-tight text-picasso-primary-800 sm:text-5xl">
            404
          </p>
          <div className="sm:ml-6">
            <div className="sm:border-l sm:border-gray-200 sm:pl-6">
              <h1 className="text-4xl font-bold text-gray-900 sm:text-5xl">
                {title}
              </h1>
              <p className="mt-4 text-base text-gray-400">{subTitle}</p>
            </div>
            <div className="mt-10 flex space-x-3 sm:border-l sm:border-transparent sm:pl-6">
              <a href="/">
                <TailwindButton type="primary">Go back home</TailwindButton>
              </a>
              <a
                href="mailto:support@usepicasso.com"
                target="_blank"
                rel="noreferrer"
              >
                <TailwindButton
                  type="secondary"
                  className="bg-picasso-primary-200"
                >
                  Contact support
                </TailwindButton>
              </a>
            </div>
          </div>
        </main>
      </div>
    </div>
  );
}

export default NotFoundPage;

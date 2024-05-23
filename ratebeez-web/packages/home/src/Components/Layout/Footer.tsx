import React from 'react';

import Link from 'src/Components/Link';

const navigation = {
  left: [
    {
      name: 'Company',
      links: [
        { name: 'About', href: '/about' },
        { name: 'Security', href: '/policies/security' },
      ],
    },
    {
      name: 'Legal',
      links: [
        { name: 'Privacy', href: '/policies/privacy' },
        { name: 'Terms of Use', href: '/policies/terms' },
      ],
    },
  ],
  right: [
    {
      name: 'Resources',
      links: [
        { name: 'Auditors', href: '/auditors' },
        {
          name: 'Self Assessments',
          href: '/assessments',
        },
      ],
    },
  ],
  social: [
    {
      name: 'Twitter',
      href: 'https://twitter.com/usepicasso',
      icon: (props) => (
        <svg fill="currentColor" viewBox="0 0 24 24" {...props}>
          <path d="M8.29 20.251c7.547 0 11.675-6.253 11.675-11.675 0-.178 0-.355-.012-.53A8.348 8.348 0 0022 5.92a8.19 8.19 0 01-2.357.646 4.118 4.118 0 001.804-2.27 8.224 8.224 0 01-2.605.996 4.107 4.107 0 00-6.993 3.743 11.65 11.65 0 01-8.457-4.287 4.106 4.106 0 001.27 5.477A4.072 4.072 0 012.8 9.713v.052a4.105 4.105 0 003.292 4.022 4.095 4.095 0 01-1.853.07 4.108 4.108 0 003.834 2.85A8.233 8.233 0 012 18.407a11.616 11.616 0 006.29 1.84" />
        </svg>
      ),
    },
    {
      name: 'GitHub',
      href: 'https://github.com/use-picasso',
      icon: (props) => (
        <svg fill="currentColor" viewBox="0 0 24 24" {...props}>
          <path
            fillRule="evenodd"
            d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z"
            clipRule="evenodd"
          />
        </svg>
      ),
    },
    {
      name: 'LinkedIn',
      href: 'https://www.linkedin.com/company/usepicasso',
      icon: (props) => (
        <svg
          fill="currentColor"
          viewBox="0 0 455 455"
          style={{
            enableBackground: 'new 0 0 455 455',
          }}
          {...props}
        >
          <path
            style={{
              fillRule: 'evenodd',
              clipRule: 'evenodd',
            }}
            d="M246.4 204.35v-.665c-.136.223-.324.446-.442.665h.442z"
          />
          <path
            style={{
              fillRule: 'evenodd',
              clipRule: 'evenodd',
            }}
            d="M0 0v455h455V0H0zm141.522 378.002H74.016V174.906h67.506v203.096zm-33.753-230.816h-.446C84.678 147.186 70 131.585 70 112.085c0-19.928 15.107-35.087 38.211-35.087 23.109 0 37.31 15.159 37.752 35.087 0 19.5-14.643 35.101-38.194 35.101zM385 378.002h-67.524V269.345c0-27.291-9.756-45.92-34.195-45.92-18.664 0-29.755 12.543-34.641 24.693-1.776 4.34-2.24 10.373-2.24 16.459v113.426h-67.537s.905-184.043 0-203.096H246.4v28.779c8.973-13.807 24.986-33.547 60.856-33.547 44.437 0 77.744 29.02 77.744 91.398v116.465z"
          />
        </svg>
      ),
    },
  ],
};

export default function Example() {
  return (
    <footer className="bg-gray-800" aria-labelledby="footer-heading">
      <h2 id="footer-heading" className="sr-only">
        Footer
      </h2>
      <div className="max-w-7xl mx-auto py-12 px-4 sm:px-6 lg:py-16 lg:px-8">
        <div className="pb-8 xl:grid xl:grid-cols-5 xl:gap-8">
          <div className="grid grid-cols-2 gap-8 xl:col-span-4">
            <div className="md:grid md:grid-cols-2 md:gap-8">
              {navigation.left.map((section) => (
                <div key={section.name}>
                  <h3 className="text-sm font-semibold text-gray-400 tracking-wider uppercase">
                    {section.name}
                  </h3>
                  <div role="list" className="mt-4 space-y-4">
                    {section.links.map((item) => (
                      <div key={item.name}>
                        <Link
                          to={item.href}
                          className="text-base text-gray-300 hover:text-white"
                        >
                          {item.name}
                        </Link>
                      </div>
                    ))}
                  </div>
                </div>
              ))}
            </div>
          </div>
          <div className="mt-12 xl:mt-0">
            {navigation.right.map((section) => (
              <div key={section.name}>
                <h3 className="text-sm font-semibold text-gray-400 tracking-wider uppercase">
                  {section.name}
                </h3>
                <div role="list" className="mt-4 space-y-4">
                  {section.links.map((item) => (
                    <div key={item.name}>
                      <Link
                        to={item.href}
                        className="text-base text-gray-300 hover:text-white"
                      >
                        {item.name}
                      </Link>
                    </div>
                  ))}
                </div>
              </div>
            ))}
          </div>
        </div>

        <div className="mt-8 border-t border-gray-700 pt-8 md:flex md:items-center md:justify-between">
          <div className="flex space-x-6 md:order-2">
            {navigation.social.map((item) => (
              <a
                key={item.name}
                href={item.href}
                target="_blank"
                rel="noopener noreferrer"
                className="text-gray-400 hover:text-gray-300"
              >
                <span className="sr-only">{item.name}</span>
                <item.icon className="h-6 w-6" aria-hidden="true" />
              </a>
            ))}
          </div>
          <p className="mt-8 text-base text-gray-400 md:mt-0 md:order-1">
            &copy; 2022 Picasso, Inc. All rights reserved.
          </p>
        </div>
      </div>
    </footer>
  );
}

import React from 'react';
import { Link, Outlet } from 'react-router-dom';

import logoPath from '@picasso/shared/assets/logo/web/svg/color.svg';
import motion from '@picasso/shared/src/Components/motion';

// Note: hemantv
// Best tool to generate logo https://myfreelogomaker.com/brandkit/86830738/logo-files

function Auth() {
  return (
    <div className="flex flex-col justify-center items-center min-h-[90vh] py-12 sm:px-6 lg:px-8 bg-slate-50">
      <div className="sm:mx-auto sm:w-full sm:max-w-md">
        <div className="text-center">
          <Link to="/">
            <img
              className="mx-auto h-10 mb-4"
              src={logoPath as any}
              alt="Picasso Logo"
            />
          </Link>
        </div>
      </div>

      <div className="mt-8 max-w-xl mx-auto w-full">
        <div className="bg-white shadow p-6">
          <motion.shift motionKey={location.pathname} values={{ x: 10 }}>
            <Outlet />
          </motion.shift>
        </div>
      </div>
    </div>
  );
}

export default Auth;

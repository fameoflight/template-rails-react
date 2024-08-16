// import React from 'react';

// import _ from 'lodash';

// import { graphql, useFragment } from 'react-relay/hooks';

// import { InlineAddressView_address$key } from '@picasso/fragments/src/InlineAddressView_address.graphql';

// const fragmentSpec = graphql`
//   fragment InlineAddressView_address on InlineAddress {
//     street1
//     street2
//     city
//     state
//     zip
//     country
//   }
// `;

// interface IInlineAddressViewProps {
//   address: InlineAddressView_address$key | null | undefined;
// }

// const InlineAddressView = (props: IInlineAddressViewProps): any => {
//   const address = useFragment(fragmentSpec, props.address);

//   if (!address) {
//     return null;
//   }

//   const data = _.compact([
//     address.street1,
//     address.street2,
//     `${address.city}, ${address.state} ${address.zip} ${address.country}`,
//   ]);

//   return (
//     <div className="space-y-1">
//       {data.map((line, index) => (
//         <div key={index}>{line}</div>
//       ))}
//     </div>
//   );
// };

// export default InlineAddressView;

import React from 'react';
import { graphql, useFragment } from 'react-relay/hooks';

import { IntegrationsCarousel_records$key } from '@picasso/fragments/src/IntegrationsCarousel_records.graphql';

import _ from 'lodash';

import { Carousel, CarouselProps } from 'antd';

import TemplateVendorView, {
  isValid,
} from 'src/Components/Integrations/TemplateVendorView';

const fragmentSpec = graphql`
  fragment IntegrationsCarousel_records on TemplatesVendor
  @relay(plural: true) {
    id
    name
    ...TemplateVendorView_record
  }
`;

interface IIntegrationsCarouselProps {
  records: IntegrationsCarousel_records$key;
  itemClassName?: string;
}

function IntegrationsCarousel(props: IIntegrationsCarouselProps) {
  const records = useFragment(fragmentSpec, props.records);
  const settings: CarouselProps = {
    dots: true,
    speed: 250,
    infinite: true,
    autoplay: true,
    easing: 'ease-in-out',
    slidesToShow: 6,
    slidesToScroll: 1,
    responsive: [
      {
        breakpoint: 1024,
        settings: {
          slidesToShow: 4,
        },
      },
      {
        breakpoint: 720,
        settings: {
          slidesToShow: 3,
        },
      },
      {
        breakpoint: 480,
        settings: {
          slidesToShow: 2,
        },
      },
    ],
  };

  const validRecords = _.filter(records, (record) => isValid(record));

  return (
    <Carousel {...settings}>
      {_.map(validRecords, (record) => (
        <div key={record.id}>
          <TemplateVendorView record={record} className={props.itemClassName} />
        </div>
      ))}
    </Carousel>
  );
}

export default IntegrationsCarousel;

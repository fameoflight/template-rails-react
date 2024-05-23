import React from 'react';
import { graphql, useFragment } from 'react-relay/hooks';

import { event } from 'nextjs-google-analytics';

import { AssessmentTemplateForm_record$key } from '@picasso/fragments/src/AssessmentTemplateForm_record.graphql';

import TailwindSimpleSteps, {
  ITailwindSimpleStep,
} from '@picasso/shared/src/Components/TailwindSimpleSteps';
import FormBuilderFields from '@picasso/shared/src/FormBuilder/FormBuilderFields';
import useJsonStore from '@picasso/shared/src/useJsonStore';

import _ from 'lodash';

import { Button, Form } from 'antd';

import AssessmentResult from 'src/Components/Assessments/AssessmentResult';

const fragmentSpec = graphql`
  fragment AssessmentTemplateForm_record on AuditCenterFrameworkAssessmentTemplate {
    id
    name
    shortId
    formData {
      sections {
        label
        description
        fields {
          name
          ...FormBuilderFields_fields
        }
      }
      ...FormBuilderView_data
    }
    ...AssessmentResult_record
  }
`;

interface IAsessmentFormProps {
  record: AssessmentTemplateForm_record$key;
  onSubmit?: (values: any) => void;
  onValuesChange?: (values: any) => void;
}

const AssessmentTemplateForm = (props: IAsessmentFormProps): any => {
  const [form] = Form.useForm();
  const record = useFragment(fragmentSpec, props.record);

  const sections = record.formData.sections;
  const [currentSection, setCurrentSection] = React.useState(0);

  const [formValues, setFormValues] = useJsonStore(
    `assessment-${record.shortId}`,
    {
      version: 1,
    }
  );

  React.useEffect(() => {
    form.setFieldsValue(formValues);
    props.onValuesChange?.(formValues);
  }, [formValues.version]);

  const onFinish = (values) => {
    props.onSubmit?.(values);
  };

  const onFinishFailed = (errorInfo) => {
    console.log('Failed:', errorInfo);
  };

  const onValuesChange = (values: any) => {
    event('assessment_form_change', {
      category: 'Assessment',
      label: record.name,
    });

    setFormValues(values);
  };

  const steps: ITailwindSimpleStep[] = _.map(
    sections,
    (section, sectionIdx) => ({
      id: sectionIdx,
      name: section.label,
      status:
        sectionIdx < currentSection
          ? 'complete'
          : sectionIdx === currentSection
          ? 'current'
          : 'upcoming',
    })
  );

  steps.push({
    id: sections.length,
    name: 'Review',
    status: currentSection === sections.length ? 'current' : 'upcoming',
  });

  return (
    <Form
      form={form}
      layout="vertical"
      onFinish={onFinish}
      requiredMark={false}
      name="AsessmentForm"
      onValuesChange={(_changedValues, allValues) => {
        onValuesChange(allValues);
      }}
      onFinishFailed={onFinishFailed}
    >
      <TailwindSimpleSteps
        steps={steps}
        onStepClick={(step) => {
          if (step.id < currentSection) {
            setCurrentSection(step.id);
          }
        }}
      >
        {currentSection < sections.length ? (
          <FormBuilderFields fields={sections[currentSection].fields} />
        ) : (
          <AssessmentResult record={record} values={formValues} />
        )}

        <Form.Item className="mt-4">
          {currentSection < sections.length && (
            <Button
              type="primary"
              onClick={() => {
                setCurrentSection(currentSection + 1);
                window.scrollTo(0, 0);
              }}
            >
              Next
            </Button>
          )}
        </Form.Item>
      </TailwindSimpleSteps>
    </Form>
  );
};

export default AssessmentTemplateForm;

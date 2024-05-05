/* eslint-disable */
import React from 'react';

import ContentLayout from '../Components/ContentLayout';

function SecurityPolicy() {
  const name = 'Picasso';

  const securityEmail = 'security@usepicasso.com';

  return (
    <ContentLayout
      title="Security Policy"
      subTitle="Last Updated: 20 August 2022"
    >
      <h2>{name} Security</h2>
      <h3>
        <br />
        {name}'s Commitment to Trust
      </h3>

      <p>
        Trust is a core principle of {name}. It’s this commitment to customer
        privacy and inspiring trust that directs the decisions we make on a
        daily basis. Trust is the responsibility of each and every employee and
        one we take seriously.
        <br />
      </p>
      <h3>Vulnerability Reporting</h3>
      <p>
        As part of our commitment to working with security researchers to make
        our platform safer, {name} operates a bug bounty program to reward those
        who find and report bugs in our platform. Our bug bounty program is
        managed through Bugcrowd. To see the terms of the program and
        participate, go to{' '}
        <a href="https://www.bugcrowd.com/" title="Bugcrowd">
          Bugcrowd
        </a>{' '}
        and sign up as a tester. If you have identified a vulnerability, please
        report it via Bugcrowd to be eligible for a reward.
      </p>
      <p>
        For other security inquiries, please send us an email at
        {securityEmail}
      </p>
      <h2>Security Assessments and Compliance</h2>
      <h3>Data Centers</h3>
      <p>
        {name} physical infrastructure is hosted and managed within Amazon’s
        secure data centers and utilize the Amazon Web Service (AWS) technology.
        Amazon continually manages risk and undergoes recurring assessments to
        ensure compliance with industry standards. Amazon’s data center
        operations have been accredited under:
      </p>
      <ul>
        <li>ISO 27001</li>
        <li>SOC 1 and SOC 2/SSAE 16/ISAE 3402 (Previously SAS 70 Type II)</li>
        <li>PCI Level 1</li>
        <li>FISMA Moderate</li>
        <li>Sarbanes-Oxley (SOX)</li>
      </ul>
      <h3>PCI</h3>
      <p>
        We use PCI compliant payment processor Stripe for encrypting and
        processing credit card payments. {name} infrastructure provider is PCI
        Level 1 compliant.
      </p>

      <h3>Physical Security</h3>
      <p>
        {name} utilizes ISO 27001 and FISMA certified data centers managed by
        Amazon. Amazon has many years of experience in designing, constructing,
        and operating large-scale data centers. This experience has been applied
        to the AWS platform and infrastructure. AWS data centers are housed in
        nondescript facilities, and critical facilities have extensive setback
        and military grade perimeter control berms as well as other natural
        boundary protection. Physical access is strictly controlled both at the
        perimeter and at building ingress points by professional security staff
        utilizing video surveillance, state-of-the-art intrusion detection
        systems, and other electronic means. Authorized staff must pass
        two-factor authentication no fewer than three times to access data
        center floors. All visitors and contractors are required to present
        identification and are signed in and continually escorted by authorized
        staff.
      </p>
      <p>
        Amazon only provides data center access and information to employees who
        have a legitimate business need for such privileges. When an employee no
        longer has a business need for these privileges, his or her access is
        immediately revoked, even if they continue to be an employee of Amazon
        or Amazon Web Services. All physical and electronic access to data
        centers by Amazon employees is logged and audited routinely.
      </p>
      <p>
        For additional information see:{' '}
        <a
          href="https://aws.amazon.com/security"
          target="_blank"
          rel="noreferrer"
        >
          https://aws.amazon.com/security{' '}
        </a>
        &nbsp;
      </p>
      <h2>Environmental Safeguards</h2>
      <h3>Fire Detection and Suppression</h3>
      <p>
        Automatic fire detection and suppression equipment has been installed to
        reduce risk. The fire detection system utilizes smoke detection sensors
        in all data center environments, mechanical and electrical
        infrastructure spaces, chiller rooms and generator equipment rooms.
        These areas are protected by either wet-pipe, double-interlocked
        pre-action, or gaseous sprinkler systems.
      </p>
      <h3>Power</h3>
      <p>
        The data center electrical power systems are designed to be fully
        redundant and maintainable without impact to operations, 24 hours a day,
        and seven days a week. Uninterruptible Power Supply (UPS) units provide
        back-up power in the event of an electrical failure for critical and
        essential loads in the facility. Data centers use generators to provide
        backup power for the entire facility.
      </p>
      <h3>Climate and Temperature Control</h3>
      <p>
        Climate control is required to maintain a constant operating temperature
        for servers and other hardware, which prevents overheating and reduces
        the possibility of service outages. Data centers are conditioned to
        maintain atmospheric conditions at optimal levels. Monitoring systems
        and data center personnel ensure temperature and humidity are at the
        appropriate levels.
      </p>
      <h3>Management</h3>
      <p>
        Data center staff monitor electrical, mechanical and life support
        systems and equipment so issues are immediately identified. Preventative
        maintenance is performed to maintain the continued operability of
        equipment.
      </p>
      <p>
        For additional information see:{' '}
        <a
          href="https://aws.amazon.com/security"
          target="_blank"
          rel="noreferrer"
        >
          https://aws.amazon.com/security
        </a>
      </p>
      <h2>Network Security</h2>
      <h3>Firewalls</h3>
      <p>
        Firewalls are utilized to restrict access to systems from external
        networks and between systems internally. By default, all access is
        denied and only explicitly allowed ports and protocols are allowed based
        on business need. &nbsp;Each system is assigned to a firewall security
        group based on the system’s function. Security groups restrict access to
        only the ports and protocols required for a system’s specific function
        to mitigate risk.
      </p>
      <p>
        Host-based firewalls restrict customer applications from establishing
        localhost connections over the loopback network interface to further
        isolate customer applications. Host-based firewalls also provide the
        ability to further limit inbound and outbound connections as needed.
      </p>
      <h3>DDoS Mitigation</h3>
      <p>
        Our infrastructure provides DDoS mitigation techniques including TCP Syn
        cookies and connection rate limiting in addition to maintaining multiple
        backbone connections and internal bandwidth capacity that exceeds the
        Internet carrier supplied bandwidth. &nbsp;We work closely with our
        providers to quickly respond to events and enable advanced DDoS
        mitigation controls when needed.
      </p>
      <h3>Spoofing and Sniffing Protections</h3>
      <p>
        Managed firewalls prevent IP, MAC, and ARP spoofing on the network and
        between virtual hosts to ensure spoofing is not possible. Packet
        sniffing is prevented by infrastructure including the hypervisor which
        will not deliver traffic to an interface which it is not addressed to.
        &nbsp;{name} utilizes Heroku which uses application isolation, operating
        system restrictions, and encrypted connections to further ensure risk is
        mitigated at all levels.
      </p>
      <h3>Port Scanning</h3>
      <p>
        Port scanning is prohibited and every reported instance is investigated
        by our infrastructure provider. &nbsp;When port scans are detected, they
        are stopped and access is blocked.
      </p>
      <h2>System Security</h2>
      <h3>System Configuration</h3>
      <p>
        System configuration and consistency is maintained through standard,
        up-to-date images, configuration management software, and by replacing
        systems with updated deployments. Systems are deployed using up-to-date
        images that are updated with configuration changes and security updates
        before deployment. Once deployed, existing systems are decommissioned
        and replaced with up-to-date systems.
      </p>
      <h2>Vulnerability Management</h2>
      <p>
        Our vulnerability management process is designed to remediate risks
        without customer interaction or impact. &nbsp;{name} is notified of
        vulnerabilities through internal and external assessments, system patch
        monitoring, and third party mailing lists and services. &nbsp;Each
        vulnerability is reviewed to determine if it is applicable to {name}{' '}
        environment, ranked based on risk, and assigned to the appropriate team
        for resolution.
      </p>
      <h3>{name} Application Security</h3>
      <p>
        We undergo penetration tests, vulnerability assessments, and source code
        reviews to assess the security of our application, architecture, and
        implementation. Our third party security assessments cover all areas of
        our platform including testing for OWASP Top 10 web application
        vulnerabilities and customer application isolation. &nbsp;{name} works
        closely with external security assessors to review the security of the{' '}
        {name} platform and applications and apply best practices.
      </p>
      <p>
        Issues found in {name} applications are risk ranked, prioritized,
        assigned to the responsible team for remediation, and {name}
        security team reviews each remediation plan to ensure proper resolution.
        <br />
      </p>
      <h2>Backups</h2>
      <h3>Application</h3>
      <p>
        {name} uses Heroku to deploy {name} web platform. Heroku platform are
        automatically backed up as part of the deployment process on secure,
        access controlled, and redundant storage. &nbsp;We use these backups to
        deploy out application across our platform and to automatically bring
        your application back online in the event of an outage.
      </p>
      <h3>Postgres Databases</h3>
      <p>
        {name} uses Heroku Postgres database. Continuous Protection keeps data
        safe on Heroku Postgres. Every change to your data is written to
        write-ahead logs, which are shipped to multi-datacenter, high-durability
        storage. In the unlikely event of unrecoverable hardware failure, these
        logs can be automatically 'replayed' to recover the database to within
        seconds of its last known state. We also back up our database to meet
        data retention requirements.
      </p>
      <h3>Customer Configuration and Meta-information</h3>
      <p>
        Your configuration and meta-information is backed up every minute to the
        same high-durability, redundant infrastructure used to store your
        database information. These frequent backups allow capturing changes
        made to the running application configuration added after the initial
        deployment.
      </p>
      <h2>
        <br />
        Disaster Recovery
      </h2>
      <h3>Applications and Databases</h3>
      <p>
        Heroku ({name} Infrastructure Provider) &nbsp;platform automatically
        restores &nbsp;applications and Heroku Postgres databases in the case of
        an outage. The Heroku platform is designed to dynamically deploy
        applications within the Heroku cloud, monitor for failures, and recover
        failed platform components including customer applications and
        databases.
      </p>
      <h3>Heroku Platform</h3>
      <p>
        The Heroku ({name} Infrastructure Provider) platform is designed for
        stability, scaling, and inherently mitigates common issues that lead to
        outages while maintaining recovery capabilities. &nbsp;Our platform
        maintains redundancy to prevent single points of failure, is able to
        replace failed components, and utilizes multiple data centers designed
        for resiliency. In the case of an outage, the platform is deployed
        across multiple data centers using current system images and data is
        restored from backups. Heroku reviews platform issues to understand the
        root cause, impact to customers, and improve the platform and processes.
      </p>
      <h3>Customer Data Retention and Destruction</h3>
      <p>
        Decommissioning hardware is managed by our infrastructure provider using
        a process designed to prevent customer data exposure. Heroku uses
        techniques outlined in DoD 5220.22-M (“National Industrial Security
        Program Operating Manual “) or NIST 800-88 (“Guidelines for Media
        Sanitization”) to destroy data.
      </p>
      <p>
        For additional information see:{' '}
        <a
          href="https://aws.amazon.com/security"
          target="_blank"
          rel="noreferrer"
        >
          https://aws.amazon.com/security
        </a>
      </p>
      <h2>
        <br />
        Privacy
      </h2>
      <p>
        {name} has a published privacy policy that clearly defines what data is
        collected and how it is used.{name} is committed to customer privacy and
        transparency.
      </p>
      <p>
        We take steps to protect the privacy of our customers and protect data
        stored within the platform. Some of the protections inherent to
        {name} products include authentication, access controls, data transport
        encryption, HTTPS support for customer applications, and the ability for
        customers to encrypt stored data. For additional information see our{' '}
        <a href="/policies/privacy" target="_blank">
          privacy policy
        </a>
        .
      </p>
      <h3>Access to Customer Data</h3>
      <p>
        {name} staff does not access or interact with customer data or
        applications as part of normal operations. There may be cases where
        {name} &nbsp;is requested to interact with customer data or applications
        at the request of the customer for support purposes or where required by
        law. Customer data is access controlled and all access by {name} staff
        is accompanied by customer approval or government mandate, reason for
        access, actions taken by staff, and support start and end time.
      </p>
      <h3>Employee Screening and Policies</h3>
      <p>
        As a condition of employment all {name} employees undergo pre-employment
        background checks and agree to company policies including security and
        acceptable use policies.
      </p>
      <h3>Security Staff</h3>
      <p>
        Our security team is lead by the Chief Information Security officer
        (CISO) and includes staff responsible for application and information
        security. The security team works closely with the entire {name}{' '}
        organization and customers to address risk and continue {name}{' '}
        commitment to trust.
      </p>
    </ContentLayout>
  );
}

export default SecurityPolicy;

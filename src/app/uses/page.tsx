import { Card } from '@/components/Card'
import { Section } from '@/components/Section'
import { SimpleLayout } from '@/components/SimpleLayout'

function ToolsSection({
  children,
  ...props
}: React.ComponentPropsWithoutRef<typeof Section>) {
  return (
    <Section {...props}>
      <ul role="list" className="space-y-16">
        {children}
      </ul>
    </Section>
  )
}

function Tool({
  title,
  href,
  children,
}: {
  title: string
  href?: string
  children: React.ReactNode
}) {
  return (
    <Card as="li">
      <Card.Title as="h3" href={href}>
        {title}
      </Card.Title>
      <Card.Description>{children}</Card.Description>
    </Card>
  )
}

export const metadata = {
  title: 'Uses',
  description:
    'Tools that I use to build software, stay productive, or just enjoy in general.',
}

export default function Uses() {
  return (
    <SimpleLayout
      title="Tools that I use to build software, stay productive, or just enjoy in general."
      intro="I get asked a lot about the things I use to build software, stay productive, or buy to fool myself into thinking I'm being productive when I'm really just procrastinating. Here's a big list of all of my favorite stuff."
    >
      <div className="space-y-20">
        <ToolsSection title="Workstation">
          <Tool title='14" Starlabs Starbook'>
            I've been using this as my main machine for a while now and it's
            been great. It's not the most powerful machine in the world but it's
            more than enough for my needs. The keyboard is great and the battery
            life is amazing. Also runs elementary OS which is a great Linux
            distro.
          </Tool>
          <Tool title="Keyboard.io Model 100 Keyboard">
            This is the best keyboard I've ever used. It's a split keyboard with
            mechanical switches and a ton of programmable keys. It's also shaped
            like a butterfly which is cool.
          </Tool>
          <Tool title="Kensington Expert Mouse Trackball">
            I've been using a trackball for years and I'm never going back. I
            love the Expert Mouse because it has a scroll ring which is super
            useful.
          </Tool>
        </ToolsSection>
        <ToolsSection title="Development tools">
          <Tool title="Emacs">
            Yeah I know, I'm one of those people. I've been using Emacs for
            years and I don't see myself switching anytime soon. I've got it
            configured just how I like it and I'm super productive with it. And
            yes I switch to VS Code when I need to pair program with someone.
          </Tool>
          <Tool title="SQLTools">
            Great VS Code extension for working with databases. I use it a lot
            and it's saved me a ton of time.
          </Tool>
          <Tool title="Copilot">
            Honestly one of the best tools I've ever used. It's like having a
            pair programmer that never gets tired and 90% has the perfect code
            snippet. 60% of the time it works every time.
          </Tool>
        </ToolsSection>
        <ToolsSection title="Design">
          <Tool title="Lucid">
            Lucid is a great tool for creating diagrams and flowcharts. I use it
            pretty often for database ERDs and system diagrams. It's simple and
            fast and easy to embed in corporate tools like Confluence.
          </Tool>
        </ToolsSection>
      </div>
    </SimpleLayout>
  )
}

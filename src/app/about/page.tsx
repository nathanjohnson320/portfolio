import { type Metadata } from 'next'
import Image from 'next/image'
import Link from 'next/link'
import clsx from 'clsx'

import { Container } from '@/components/Container'
import {
  GitHubIcon,
  InstagramIcon,
  LinkedInIcon,
  XIcon,
} from '@/components/SocialIcons'
import portraitImage from '@/images/portrait.jpg'

function SocialLink({
  className,
  href,
  children,
  icon: Icon,
}: {
  className?: string
  href: string
  icon: React.ComponentType<{ className?: string }>
  children: React.ReactNode
}) {
  return (
    <li className={clsx(className, 'flex')}>
      <Link
        href={href}
        className="group flex text-sm font-medium text-zinc-800 transition hover:text-teal-500 dark:text-zinc-200 dark:hover:text-teal-500"
      >
        <Icon className="h-6 w-6 flex-none fill-zinc-500 transition group-hover:fill-teal-500" />
        <span className="ml-4">{children}</span>
      </Link>
    </li>
  )
}

function MailIcon(props: React.ComponentPropsWithoutRef<'svg'>) {
  return (
    <svg viewBox="0 0 24 24" aria-hidden="true" {...props}>
      <path
        fillRule="evenodd"
        d="M6 5a3 3 0 0 0-3 3v8a3 3 0 0 0 3 3h12a3 3 0 0 0 3-3V8a3 3 0 0 0-3-3H6Zm.245 2.187a.75.75 0 0 0-.99 1.126l6.25 5.5a.75.75 0 0 0 .99 0l6.25-5.5a.75.75 0 0 0-.99-1.126L12 12.251 6.245 7.187Z"
      />
    </svg>
  )
}

export const metadata: Metadata = {
  title: 'About',
  description:
    "I'm Nathan Johnson. I live in Tallinn Estonia, where I've been writing software and painting for the last 12 years.",
}

export default function About() {
  return (
    <Container className="mt-16 sm:mt-32">
      <div className="grid grid-cols-1 gap-y-16 lg:grid-cols-2 lg:grid-rows-[auto_1fr] lg:gap-y-12">
        <div className="lg:pl-20">
          <div className="max-w-xs px-2.5 lg:max-w-none">
            <Image
              src={portraitImage}
              alt=""
              sizes="(min-width: 1024px) 32rem, 20rem"
              className="aspect-square rotate-3 rounded-2xl bg-zinc-100 object-cover dark:bg-zinc-800"
            />
          </div>
        </div>
        <div className="lg:order-first lg:row-span-2">
          <h1 className="text-4xl font-bold tracking-tight text-zinc-800 sm:text-5xl dark:text-zinc-100">
            I'm Nathan Johnson. Currently working with STORD building out the
            cloud supply chain and oil painting on my YouTube channel in my free
            time.
          </h1>
          <div className="mt-6 space-y-7 text-base text-zinc-600 dark:text-zinc-400">
            <p>
              I've been writing software for the last 12 years, and painting for
              the last 4. I live in Pineville with my cat KitKat right near
              downtown.
            </p>
            <p>
              My career in software has been focused on building web
              applications and APIs, working with a variety of technologies
              including everything from backend frameworks like Laravel,
              frontend libraries like React, data science transformers in Python
              for Stitch, and cloud services like AWS. I've even managed teams
              of up to 8 developers, and have started a couple of companies
              along the way (Tomahawk + Venu now RIP).
            </p>
            <p>
              In 2020 I decided to learn oil painting inspired by the legendary
              Bob Ross, and have been sharing my journey on YouTube ever since.
              I focus on oil painting, and have a passion for landscapes and
              seascapes. I'm currently working on a series of paintings inspired
              by the Blue Ridge Mountains and hope to have them up in a gallery
              soon.
            </p>
            <p>
              Today I'm working with STORD building out the cloud supply chain
              and oil painting on my YouTube channel in my free time. I'm always
              looking for new opportunities to learn and grow, so if you have
              any ideas or projects you'd like to collaborate on, please reach
              out!
            </p>
          </div>
        </div>
        <div className="lg:pl-20">
          <ul role="list">
            <SocialLink
              href="https://www.instagram.com/paint.by.nate/"
              icon={InstagramIcon}
            >
              Follow on Instagram
            </SocialLink>
            <SocialLink
              href="https://github.com/nathanjohnson320"
              icon={GitHubIcon}
              className="mt-4"
            >
              Follow on GitHub
            </SocialLink>
            <SocialLink
              href="https://www.linkedin.com/in/%F0%9F%8D%BB-nathaniel-j-b8659562/"
              icon={LinkedInIcon}
              className="mt-4"
            >
              Follow on LinkedIn
            </SocialLink>
            <SocialLink
              className="mt-4"
              href="https://x.com/PaintByNate"
              icon={XIcon}
            >
              Follow on X
            </SocialLink>
            <SocialLink
              href="mailto:nate@paintbynate.art"
              icon={MailIcon}
              className="mt-8 border-t border-zinc-100 pt-8 dark:border-zinc-700/40"
            >
              nate@paintbynate.art
            </SocialLink>
          </ul>
        </div>
      </div>
    </Container>
  )
}

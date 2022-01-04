# MDX 본문에서 외부 링크 클릭하면 새 창이 뜨도록 하기

MDX 내부에서 마크다운의 `[text](link)` 문법으로 링크를 생성할 경우, 새 창이 뜨지 않고 바로 해당 링크로 이동하게 된다. kramdown 등 일부 마크다운 렌더링 엔진에서는 `[text](link){:target="_blank"}` 등의 추가적인 문법을 통해 이러한 기능을 적용할 수 있지만 MDX에서는 발견할 수 없었다. 블로그를 위해 사용하는 경우, 대부분의 외부 링크는 새창이 뜨는 것을 기대하는 것이라고 가정하여 링크 태그의 동작을 수정해보기로 했다.

## 1. 파일 추가 : `CustomLink.jsx`

원래 문서에서 다음과 같은 항목을 수정했다.

- jsx 파일로 둘 경우, React를 임포트하지 않으면 에러가 발생한다.
- `domainRegex` 를 정의할 때, localhost 또는 실제 도메인을 체크하도록 했다. (다른 블로그에서 사용하려면, 이 부분을 수정해야 한다.)

```jsx
import React from 'react'
import PropTypes from 'prop-types'
import { Link as GatsbyLink } from 'gatsby'
import { Link } from 'theme-ui'

const domainRegex = /http[s]*:\/\/[www.]*YOURDOMAIN\.com[/]?/
const MarkdownLink = ({ href, ...rest }) => {
  const sameDomain = domainRegex.test(href)

  if (sameDomain) {
    href = href.replace(domainRegex, '/')
  }

  if (href.startsWith('/')) {
    return <GatsbyLink data-link-internal to={href} {...rest} />
  }

  // Treat urls that aren't web protocols as "normal" links
  if (!href.startsWith('http')) {
    return <a href={href} {...rest} /> // eslint-disable-line jsx-a11y/anchor-has-content
  }

  return (
    <Link
      data-link-external
      href={href}
      target="_blank"
      rel="noopener noreferrer nofollow"
      {...rest}
    />
  )
}

MarkdownLink.propTypes = {
  href: PropTypes.string.isRequired,
}

export default MarkdownLink
```

## 2. Component Shadowing

- 사전에 정의된 MDX 용 컴포넌트를 `MDXProvider` 에 추가할 때, 위에서 정의한 함수가 a 태그에 대응되도록 한다.
- 컴포넌트 쪽에서 쉐도잉해도 되지만, 서로 임포트하고 있는 디펜던시를 모두 쉐도잉 처리하는게 귀찮아서 MDXProvider 설정 단계에서 쉐도잉하도록 했다.

```jsx
import React from 'react'
import { MDXRenderer } from 'gatsby-plugin-mdx'
import { MDXProvider } from '@theme-ui/mdx'
import components from '@components/Mdx'
import MarkdownLink from './CustomLink'

export const PostBody = ({ body }) => {
  return (
    <MDXProvider components={{
        ...components,
        a: (props) => <MarkdownLink {...props} />,
    }}>
      <MDXRenderer>{body}</MDXRenderer>
    </MDXProvider>
  )
}
```

위 작업은 다음 문서를 바탕으로 한다.

[MDX link routing in Gatsby - Zach Schnackel](https://zslabs.com/articles/mdx-link-routing-in-gatsby)

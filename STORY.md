# Project Story — from my Next.js blog to a real-time clickstream pipeline

> The narrative to tell in interviews. It builds on real, verifiable work (a deployed
> Next.js content site with real readers) and adds one honest chapter: extending it
> with a Kafka streaming pipeline I built myself.

## The arc (motivation → gap → build → result)

**1. Where I started (true):**
"I built and deployed a content/blog site in Next.js with real readers. For analytics
I used Google Analytics, so I could see page views and traffic."

**2. The gap I noticed (true and thoughtful):**
"But GA gave me *sampled, delayed, aggregated* data I didn't own. I couldn't see engagement
in real time, I couldn't keep the raw events, and I couldn't build custom metrics like
'which articles get read to the end' or 'which CTA actually converts.' I was the *producer*
of click events into a black box I didn't control."

**3. What I built (the project):**
"So I built the other half — a first-party, real-time clickstream pipeline. I added a
lightweight tracker to the Next.js site that emits engagement events (article views, link
clicks, scroll depth, newsletter CTA clicks) to a Kafka pipeline I run on AWS free tier.
A consumer aggregates them in real time and stores raw events for replay."

**4. The result (outcome + learning):**
"Now I own the full loop: a reader clicks on my live site → the event streams through Kafka →
I see engagement update in real time, and every raw event is archived so I can compute any
new metric later. It turned my front-end experience into an end-to-end data pipeline."

## Why each piece exists (be ready to defend these)

| Decision | The reason (say this) |
|----------|----------------------|
| Built my own pipeline instead of just using GA | "First-party data I own, real-time, and raw events I can reprocess for new metrics." |
| Kafka in the middle | "Decouples my site from analytics — the page just fires an event and stays fast; Kafka buffers bursts (e.g. a post going viral) and lets multiple consumers read the same stream." |
| Partition by `session_id` | "Keeps one reader's events ordered within a partition." |
| Two sinks (DynamoDB + S3) | "DynamoDB for real-time dashboards, S3 as a data lake for replay and batch analysis." |
| Self-hosted Kafka on EC2 | "Free tier — MSK isn't free. Also taught me Kafka's networking internals." |
| Scroll-depth + dwell events | "Page views lie about engagement; scroll depth and dwell time show who actually *read* the article." |

## The events I track (maps to a real blog)

- `article_view` — a post was opened
- `scroll_depth` (25/50/75/100%) — how far readers actually get
- `link_click` / `outbound_click` — internal navigation vs. leaving the site
- `cta_click` — newsletter signup / subscribe button
- `share_click` — social shares
- `search` — on-site search usage

See [src/schemas/click_event.schema.json](src/schemas/click_event.schema.json).

## How the site connects to the pipeline

```
Next.js blog (real, deployed)
   │  reader clicks / scrolls
   ▼
useTrackEvent() hook  ──fetch/beacon──▶  API Gateway ──▶ Lambda producer
                                                              │ validates vs schema
                                                              ▼
                                                    Kafka topic: clickthrough.events
                                                              │
                                                              ▼
                                            Lambda consumer (aggregate + enrich)
                                                     │                  │
                                                     ▼                  ▼
                                          DynamoDB (live metrics)   S3 (raw archive)
```

## Honest boundaries (say these before they ask)

- "It's single-broker on free tier — no HA, replication factor 1. Production would be a
  3-broker cluster or MSK."
- "Small volume — hundreds of events, not the trillions Netflix/LinkedIn handle. Same
  architecture, different scale."
- "I kept it at-least-once with an idempotent consumer; exactly-once wasn't worth the cost
  for engagement analytics."

## The one-line pitch

> "I had a deployed Next.js blog and relied on Google Analytics — but I wanted first-party,
> real-time engagement data I actually owned. So I built a Kafka clickstream pipeline on AWS
> free tier that ingests reader events straight from my site, aggregates them live, and
> archives the raw stream for replay. It connected my front-end work to real data engineering."

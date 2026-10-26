-- جدول رسايل فورم «تواصل معنا» في موقع لوليتا
-- شغّل الملف ده مرة واحدة من Supabase → SQL Editor.
-- الزوار يقدروا يضيفوا رسالة بس: من غير قراية ولا تعديل ولا مسح.

create table if not exists public.messages (
  id         bigint generated always as identity primary key,
  name       text not null check (char_length(btrim(name)) between 1 and 100),
  phone      text not null check (phone ~ '^[0-9+ -]{8,20}$'),
  message    text not null check (char_length(btrim(message)) between 1 and 2000),
  created_at timestamptz not null default now()   -- وقت الإرسال
);

-- تشغيل Row Level Security
alter table public.messages enable row level security;

-- شيل كل الصلاحيات الافتراضية من الزوار، وادّيهم إضافة بس
-- (على name و phone و message بس، فوقت الإرسال بيتحط تلقائي وماحدش يقدر يغيّره)
revoke all on table public.messages from anon, authenticated;
grant insert (name, phone, message) on table public.messages to anon;

-- السياسة: الإضافة بس. مفيش سياسات select / update / delete، فكلهم ممنوعين.
drop policy if exists "Visitors can send messages" on public.messages;
create policy "Visitors can send messages"
  on public.messages
  for insert
  to anon
  with check (true);

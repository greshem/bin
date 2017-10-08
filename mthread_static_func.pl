#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
#注意在linux 下__stdcall  宏定义成了 空.
class Data_cache
{
	static void * __stdcall  Update( void *);
	MThread m_update_thread;
	int Start();
}

void * __stdcall Data_cache::Update(void *in)
{
	Data_cache * cache=(Data_cache *)in;
	cache->loop();
}

Data_cache::Start()
{
	m_update_thread.StartThread(update, this);
}


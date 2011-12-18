package AdventCalendar2011::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::Lite;

get '/' => sub {
    my ($c) = @_;
    $DB::single=1;
    my $sqlstr =<<EOF;
select
  parent.id as id
 ,parent.title as title
 ,parent.url as url
 ,coalesce(count,0) as count
from
 (select * from url_list where parent_id is null) as parent
  left outer join
 (select parent_id, count(*) as count from url_list where parent_id!='' group by parent_id) as child
on parent.id = child.parent_id
EOF
    my $rs_parent = $c->dbh->selectall_arrayref($sqlstr, +{Slice=>{}});
    my $rs_child  = $c->dbh->selectall_arrayref("select * from url_list where parent_id!=''",  +{Slice=>{}});

    #warn Dump $rs;
    return $c->render('index.tt',
        {
            rs_parent => $rs_parent,
            rs_child  => $rs_child,
        }
    );
};

1;

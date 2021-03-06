package KbnAuth::Controller::Kibana;
use Mojo::Base 'Mojolicious::Controller';

sub webui {
    my $self = shift;
    $self->render;
}

sub config {
    my $self = shift;
    $self->stash( route => $self->user('route')
          // '/dashboard/file/default.json' );
    $self->render( format => 'js' );
}

sub dashboard {
    my $self = shift;
    my $file = $self->param('file');
    $self->reply->static("dashboards/$file");
}

sub index {
    my $self = shift;
    my $user = $self->param('user') // '';
    my $pass = $self->param('pass') // '';
    return $self->render unless $self->users->check( $user, $pass );
    $self->session( user => $user );
    $self->redirect_to('webui');
}

sub logged_in {
    my $self = shift;
    return 1 if $self->session('user');
    $self->redirect_to('index');
    return undef;
}

sub logout {
    my $self = shift;
    delete $self->users->cache->{$self->session('user')};
    $self->session( expires => 1 );
    $self->redirect_to('index');
}

1;

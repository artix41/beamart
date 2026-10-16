# Make the shared style available to presentations in subdirectories.
use Cwd qw(abs_path);
ensure_path('TEXINPUTS', abs_path('.'), abs_path('..'));

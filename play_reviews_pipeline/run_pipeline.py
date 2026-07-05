import argparse # command line arguments
import os # reading and writing files
import shutil # for same purpose
import subprocess # run other scripts
import sys # for curent python?


def run(cmd, env=None, cwd=None):
    subprocess.run(cmd, check=True, env=env, cwd=cwd)


def safe_folder_name(name):
    cleaned = name.strip().replace("/", "-").replace("\\", "-")
    if not cleaned:
        raise ValueError("app name cannot be empty")
    return cleaned


def ensure_app_notebook(app_dir):
    target = os.path.join(app_dir, "analysis.ipynb")
    if os.path.exists(target):
        return target

    source = os.path.join(os.path.dirname(__file__), "analysis.ipynb")
    shutil.copy2(source, target)
    return target


def execute_notebook(env=None, cwd=None):
    commands = [
        [
            "jupyter",
            "nbconvert",
            "--to",
            "notebook",
            "--execute",
            "--inplace",
            "analysis.ipynb",
        ],
        [
            "jupyter-nbconvert",
            "--to",
            "notebook",
            "--execute",
            "--inplace",
            "analysis.ipynb",
        ],
        [
            sys.executable,
            "-m",
            "nbconvert",
            "--to",
            "notebook",
            "--execute",
            "--inplace",
            "analysis.ipynb",
        ],
    ]

    last_error = None
    for cmd in commands:
        try:
            run(cmd, env=env, cwd=cwd)
            return
        except (FileNotFoundError, subprocess.CalledProcessError) as exc:
            last_error = exc

    raise RuntimeError(
        "Notebook execution failed. Install nbconvert in this environment "
        "(e.g. `pip install nbconvert jupyter`) and retry."
    ) from last_error


def main():
    parser = argparse.ArgumentParser(description="Run Google Play reviews pipeline")
    parser.add_argument("--app-id", required=True, help="Google Play app id, e.g. com.example.app")
    parser.add_argument("--app-name", required=True, help="Folder name for this app run")
    args = parser.parse_args()

    env = os.environ.copy()
    env["APP_ID"] = args.app_id

    apps_root = os.path.join(os.path.dirname(__file__), "apps")
    app_dir = os.path.join(apps_root, safe_folder_name(args.app_name))
    os.makedirs(app_dir, exist_ok=True)
    os.makedirs(os.path.join(app_dir, "data"), exist_ok=True)
    os.makedirs(os.path.join(app_dir, "outputs"), exist_ok=True)
    ensure_app_notebook(app_dir)

    run([sys.executable, os.path.join(os.path.dirname(__file__), "scraper.py")], env=env, cwd=app_dir)
    execute_notebook(env=env, cwd=app_dir)


if __name__ == "__main__":
    main()

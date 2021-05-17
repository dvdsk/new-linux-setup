from os import path
from setuptools import find_packages, setup

here = path.abspath(path.dirname(__file__))
requirements_path = path.join(here, "requirements.txt")


def read_requirements(path):
    try:
        with open(path, mode="rt", encoding="utf-8") as fp:
            return list(
                filter(None, [line.split("#")[0].strip() for line in fp])  # noqa:C407
            )
    except IndexError:
        raise RuntimeError("{} is broken".format(path))


setup(
    name="",
    description="",
    install_requires=read_requirements(requirements_path),
    package_dir={"": "src"},
    python_requires=">=3.8",
)

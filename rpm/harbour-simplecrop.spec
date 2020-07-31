# 
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.27
# 

Name:       harbour-simplecrop

# >> macros
# << macros

Summary:    SimpleCropper
Version:    0.5
Release:    1
Group:      Qt/Qt
License:    LICENSE
URL:        http://example.org/
Source0:    %{name}-%{version}.tar.bz2
Source100:  harbour-simplecrop.yaml
Requires:   sailfishsilica-qt5 >= 0.10.9
Requires:   libsailfishapp-launcher
Requires:   pyotherside-qml-plugin-python3-qt5 >= 1.5

BuildRequires:  pkgconfig(sailfishapp) >= 1.0.3
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  desktop-file-utils
BuildRequires:  python3-devel
BuildRequires:  python-setuptools
BuildRequires:  fdupes
BuildRequires:  freetype-devel
BuildRequires:  libjpeg-turbo-devel
BuildRequires:  openjpeg-devel
BuildRequires:  libtiff-devel
BuildRequires:  libwebp-devel
BuildRequires:  unzip
BuildRequires:  zlib-devel
BuildRequires:	python3-setuptools
Requires:       python3-base

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root


%description
Short description of my Sailfish OS Application


%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%build
# >> build pre
# << build pre
cd pillow
python3 setup.py build
cd ..
%qmake5 

make %{?_smp_mflags}

# >> build post
# << build post

%install
rm -rf %{buildroot}
# >> install pre
# << install pre
%qmake5_install
mkdir -p $RPM_BUILD_ROOT/%{_datadir}/%{name}/py
cd pillow
python3 setup.py install --root $RPM_BUILD_ROOT/%{_datadir}/%{name}/py
# >> install post
# << install post

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%defattr(0644,root,root,-)
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
%{_datadir}/%{name}/py/PIL
%{_datadir}/%{name}/py/Pillow*
# >> files
# << files

use std::{env, error, fmt, fs, io, path::PathBuf};

#[derive(Debug)]
struct BadExtension;

impl error::Error for BadExtension {}

impl fmt::Display for BadExtension {
    fn fmt(&self, fmt: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(fmt, "bad extension")
    }
}

fn main() -> Result<(), Box<error::Error>> {
    let mut args = env::args();
    args.next();

    let archive = PathBuf::from(args.next().ok_or_else(|| "missing <archive>")?);

    let is_tar_gz = archive
        .file_name()
        .and_then(|f| f.to_str())
        .map(|f| f.ends_with(".tar.gz"))
        .unwrap_or(false);

    match archive.extension().and_then(|e| e.to_str()) {
        Some("zip") => {
            println!("Building zip: {}", archive.display());

            let options = zip::write::FileOptions::default()
                .compression_method(zip::CompressionMethod::Bzip2);
            let mut zip = zip::ZipWriter::new(fs::File::create(archive)?);

            for f in args {
                println!("Adding file: {}", f);
                zip.start_file(f.as_str(), options.clone())?;
                io::copy(&mut fs::File::open(&f)?, &mut zip)?;
            }

            zip.finish()?;
        }
        _ if is_tar_gz => {
            println!("Building tar.gz: {}", archive.display());

            let mut a = tar::Builder::new(flate2::write::GzEncoder::new(
                fs::File::create(archive)?,
                flate2::Compression::default(),
            ));

            for f in args {
                println!("Adding file: {}", f);
                a.append_path(f)?;
            }
        }
        _ => {
            return Err(Box::new(BadExtension));
        }
    }

    Ok(())
}

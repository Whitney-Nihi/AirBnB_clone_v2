#!/usr/bin/env python3
from fabric.api import local
from datetime import datetime
import os

def do_pack():
    """
    Compress the contents of the web_static folder into a .tgz archive.
    """
    # Create versions directory if it doesn't exist
    if not os.path.exists('versions'):
        os.makedirs('versions')
    
    # Generate timestamp for the archive name
    now = datetime.now()
    timestamp = now.strftime('%Y%m%d%H%M%S')
    archive_name = f"web_static_{timestamp}.tgz"
    archive_path = os.path.join('versions', archive_name)

    try:
        # Create the .tgz archive
        local(f'tar -cvzf {archive_path} web_static')
        # Return the archive path if successful
        return archive_path
    except:
        # Return None if the archive creation fails
        return None

#!/usr/bin/env python3

import os
import time
import subprocess
import atexit
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

# Paths
home = os.path.expanduser("~")
wallpaper_file = os.path.join(home, ".last_selected_wallpaper")
current_wallpaper_file = os.path.join(home, ".current_lockscreen_wallpaper")
pid_file = os.path.join(home, ".monitor_lockscreen_wallpaper.pid")

# Ensure only one instance is running
def check_if_running():
    if os.path.isfile(pid_file):
        with open(pid_file, 'r') as f:
            pid = int(f.read().strip())
        if os.path.exists(f"/proc/{pid}"):
            print(f"Script is already running with PID {pid}")
            exit(0)

    with open(pid_file, 'w') as f:
        f.write(str(os.getpid()))

    def remove_pid_file():
        os.remove(pid_file)

    atexit.register(remove_pid_file)

class WallpaperEventHandler(FileSystemEventHandler):
    def __init__(self):
        super().__init__()
        self.last_wallpaper = self.read_first_line(current_wallpaper_file)

    def on_modified(self, event):
        if event.src_path == wallpaper_file:
            new_wallpaper = self.read_first_line(wallpaper_file)
            if new_wallpaper and new_wallpaper != self.last_wallpaper:
                wallpaper_path = os.path.join(home, "Pictures", "Wallpapers", new_wallpaper)
                self.update_lockscreen_wallpaper(wallpaper_path)
                self.write_line(current_wallpaper_file, new_wallpaper)
                self.last_wallpaper = new_wallpaper

    @staticmethod
    def read_first_line(filepath):
        try:
            with open(filepath, 'r') as file:
                return file.readline().strip()
        except FileNotFoundError:
            return None

    @staticmethod
    def write_line(filepath, line):
        with open(filepath, 'w') as file:
            file.write(line + '\n')

    @staticmethod
    def update_lockscreen_wallpaper(wallpaper_path):
        subprocess.run(["betterlockscreen", "-u", wallpaper_path])

def main():
    check_if_running()

    event_handler = WallpaperEventHandler()
    observer = Observer()
    observer.schedule(event_handler, path=os.path.dirname(wallpaper_file), recursive=False)
    observer.start()

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()

if __name__ == "__main__":
    main()

package com.tasks.notes.adapters;

import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.tasks.notes.classes.Note;
import com.tasks.notes.R;

public class NotesAdapter extends RecyclerView.Adapter<NotesAdapter.ViewHolder> {
    public interface OnItemClickListener {
        void onItemClick(View v, int position);
    }

    private static OnItemClickListener mListener;
    private Note[] mData;

    public NotesAdapter(Note[] objects, OnItemClickListener listener) {
        mData = objects;
        mListener = listener;
    }

    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.note_item, parent, false);
        return new ViewHolder(v);
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        holder.title.setText(mData[position].getTitle());
        holder.description.setText(mData[position].getDescription());
        holder.container.setBackgroundColor(mData[position].getColor());
        holder.title.setVisibility("".equals(mData[position].getTitle()) ?
                View.GONE : View.VISIBLE);
        holder.description.setVisibility("".equals(mData[position].getDescription()) ?
                View.GONE : View.VISIBLE);
    }

    @Override
    public int getItemCount() {
        return mData.length;
    }

    protected static class ViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
        TextView title;
        TextView description;
        RelativeLayout container;

        public ViewHolder(View viewItem) {
            super(viewItem);
            title = (TextView) viewItem.findViewById(R.id.list_item_title);
            description = (TextView) viewItem.findViewById(R.id.list_item_description);
            container = (RelativeLayout) viewItem.findViewById(R.id.list_item_container);

            viewItem.setOnClickListener(this);
        }

        @Override
        public void onClick(View v) {
            mListener.onItemClick(v, this.getLayoutPosition());
        }
    }
}